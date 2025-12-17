import 'package:cloud_firestore/cloud_firestore.dart';

class QueueToken {
  final String id;
  final String slotName;
  final int? number; // universal queue number (optional)
  final String? uid;
  final String? userEmail;
  final String status; // waiting / called / done
  final Timestamp? createdAt;
  final Timestamp? calledAt;
  final Timestamp? finishedAt;
  final String? calledBy;

  QueueToken({
    required this.id,
    required this.slotName,
    this.number,
    this.uid,
    this.userEmail,
    this.status = 'waiting',
    this.createdAt,
    this.calledAt,
    this.finishedAt,
    this.calledBy,
  });

  factory QueueToken.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return QueueToken(
      id: doc.id,
      slotName: data['slotName'] as String? ?? '',
      number: data['number'] as int?,
      uid: data['uid'] as String?,
      userEmail: data['userEmail'] as String?,
      status: data['status'] as String? ?? 'waiting',
      createdAt: data['createdAt'] as Timestamp?,
      calledAt: data['calledAt'] as Timestamp?,
      finishedAt: data['finishedAt'] as Timestamp?,
      calledBy: data['calledBy'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'slotName': slotName,
        if (number != null) 'number': number,
        'uid': uid,
        'userEmail': userEmail,
        'status': status,
        'createdAt': createdAt ?? FieldValue.serverTimestamp(),
        if (calledAt != null) 'calledAt': calledAt,
        if (finishedAt != null) 'finishedAt': finishedAt,
        if (calledBy != null) 'calledBy': calledBy,
      };
}
