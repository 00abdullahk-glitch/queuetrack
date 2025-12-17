import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semesterproject/models/queue_token.dart';

class QueueRepo {
  CollectionReference<Map<String, dynamic>> get _col => FirebaseFirestore.instance.collection('tokens');
  DocumentReference<Map<String, dynamic>> get _meta => FirebaseFirestore.instance.collection('meta').doc('queue');

  /// Backwards-compatible stream that orders by createdAt (existing behaviour)
  Stream<List<QueueToken>> streamTokens() {
    return _col.orderBy('createdAt', descending: false).snapshots().map((snap) {
      return snap.docs.map((d) => QueueToken.fromDoc(d)).toList();
    });
  }

  /// Stream all tokens ordered by numeric queue number (new universal queue)
  Stream<List<QueueToken>> streamAllTokens({String? status}) {
    Query<Map<String, dynamic>> q = _col.orderBy('number', descending: false);
    if (status != null) q = q.where('status', isEqualTo: status);
    return q.snapshots().map((snap) => snap.docs.map((d) => QueueToken.fromDoc(d)).toList());
  }

  /// Stream the user's active token (waiting or called)
  Stream<QueueToken?> streamUserToken(String uid) {
    final q = _col.where('uid', isEqualTo: uid).where('status', whereIn: ['waiting', 'called']).limit(1);
    return q.snapshots().map((snap) {
      if (snap.docs.isEmpty) return null;
      return QueueToken.fromDoc(snap.docs.first);
    });
  }

  /// Create a token using a transaction-safe incrementing counter.
  /// Returns {'id': docId, 'number': assignedNumber}.
  Future<Map<String, dynamic>> createToken({String? uid, String? userEmail}) async {
    return FirebaseFirestore.instance.runTransaction((tx) async {
      final metaSnap = await tx.get(_meta);
      int next = 1;
      if (metaSnap.exists) {
        final data = metaSnap.data();
        next = (data?['nextNumber'] as int?) ?? 1;
      }

      tx.set(_meta, {'nextNumber': next + 1}, SetOptions(merge: true));

      final docRef = _col.doc();
      final data = {
        'number': next,
        'uid': uid,
        'userEmail': userEmail,
        'status': 'waiting',
        'createdAt': FieldValue.serverTimestamp(),
      };

      tx.set(docRef, data);

      return {'id': docRef.id, 'number': next};
    });
  }

  /// Existing behaviour kept for slot-based tokens
  Future<String> takeToken({required String slotName, String? uid, String? userEmail}) async {
    final doc = await _col.add({
      'slotName': slotName,
      'uid': uid,
      'userEmail': userEmail,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  Future<void> releaseToken(String id) async {
    await _col.doc(id).delete();
  }

  Future<bool> isSlotAvailable(String slotName) async {
    final q = await _col.where('slotName', isEqualTo: slotName).limit(1).get();
    return q.docs.isEmpty;
  }

  /// Owner actions: call the next waiting token (mark 'called')
  Future<QueueToken?> callNext({String? calledBy}) async {
    final q = await _col.where('status', isEqualTo: 'waiting').orderBy('number').limit(1).get();
    if (q.docs.isEmpty) return null;
    final doc = q.docs.first;
    await _col.doc(doc.id).update({'status': 'called', 'calledAt': FieldValue.serverTimestamp(), 'calledBy': calledBy});
    final updated = await _col.doc(doc.id).get();
    return QueueToken.fromDoc(updated);
  }

  /// Mark the token as finished
  Future<void> finishToken(String id) async {
    await _col.doc(id).update({'status': 'done', 'finishedAt': FieldValue.serverTimestamp()});
  }
}
