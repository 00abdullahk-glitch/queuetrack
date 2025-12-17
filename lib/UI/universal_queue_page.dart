import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesterproject/viewmodels/auth_controller.dart';
import 'package:semesterproject/providers/queue_repo.dart';
import 'package:semesterproject/models/queue_token.dart';

class UniversalQueuePage extends StatefulWidget {
  const UniversalQueuePage({super.key});

  @override
  State<UniversalQueuePage> createState() => _UniversalQueuePageState();
}

class _UniversalQueuePageState extends State<UniversalQueuePage> {
  final _repo = QueueRepo();
  final authC = Get.find<AuthController>();
  StreamSubscription<QueueToken?>? _sub;
  QueueToken? _myToken;

  @override
  void initState() {
    super.initState();

    final uid = authC.user.value?.uid;
    if (uid != null) {
      _sub = _repo.streamUserToken(uid).listen((t) {
        // show in-app notifications when status changes
        if (_myToken == null && t != null) {
          // new token assigned
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Token #${t.number} created — status: ${t.status}')));
        } else if (_myToken != null && t != null && _myToken!.status != t.status) {
          if (t.status == 'called') {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Your token #${t.number} is being called')));
          } else if (t.status == 'done') {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Your token #${t.number} is finished')));
          }
        }
        setState(() => _myToken = t);
      });
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Future<void> _createToken() async {
    final uid = authC.user.value?.uid;
    final email = authC.user.value?.email;
    try {
      final res = await _repo.createToken(uid: uid, userEmail: email);
      final num = res['number'];
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Token #$num created')));
    } catch (e) {
      Get.log('createToken error: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not create token')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Universal Queue')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('My token', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _myToken == null
                        ? const Text('You have no active token')
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Number: #${_myToken?.number ?? "-"}'),
                              const SizedBox(height: 6),
                              Text('Status: ${_myToken?.status ?? "-"}'),
                            ],
                          ),
                    ElevatedButton(
                      onPressed: _myToken != null ? null : _createToken,
                      child: const Text('Get Token'),
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            const Text('Queue preview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            Expanded(
              child: StreamBuilder<List<QueueToken>>(
                stream: _repo.streamAllTokens(),
                builder: (context, snap) {
                  final tokens = snap.data ?? [];
                  if (tokens.isEmpty) return const Center(child: Text('No tokens'));

                  return ListView.builder(
                    itemCount: tokens.length,
                    itemBuilder: (_, i) {
                      final t = tokens[i];
                      return ListTile(
                        leading: CircleAvatar(child: Text('${t.number ?? i + 1}')),
                        title: Text('#${t.number ?? "-"} — ${t.userEmail ?? t.uid ?? "Unknown"}'),
                        subtitle: Text('Status: ${t.status}'),
                        trailing: t.status == 'called' ? const Icon(Icons.campaign, color: Colors.orange) : null,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
