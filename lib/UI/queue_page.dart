import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesterproject/viewmodels/auth_controller.dart';
import 'package:semesterproject/providers/queue_repo.dart';
import 'package:semesterproject/models/queue_token.dart';

class QueuePage extends StatelessWidget {
  QueuePage({Key? key}) : super(key: key);

  final _slots = List.generate(5, (i) => 'Slot ${i + 1}');
  final _repo = QueueRepo();
  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Queue')),
      body: StreamBuilder<List<QueueToken>>(
        stream: _repo.streamTokens(),
        builder: (context, snapshot) {
          final tokens = snapshot.data ?? [];

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: _slots.length,
            itemBuilder: (context, index) {
              final slot = _slots[index];
              final occupant = tokens.firstWhere(
                (t) => t.slotName == slot,
                orElse: () => QueueToken(id: '', slotName: '', uid: null, userEmail: null, createdAt: null),
              );

              final occupied = occupant.id.isNotEmpty;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text(slot),
                  subtitle: occupied
                      ? Text('Taken by ${occupant.userEmail ?? occupant.uid}')
                      : const Text('Available'),
                  trailing: occupied
                      ? occupant.uid == authC.user.value?.uid
                          ? TextButton(
                              child: const Text('Release'),
                              onPressed: () async {
                                await _repo.releaseToken(occupant.id);
                                Get.snackbar('Queue', 'Token released');
                              },
                            )
                          : const Text('Taken')
                      : ElevatedButton(
                          child: const Text('Take'),
                          onPressed: () async {
                            final uid = authC.user.value?.uid;
                            final email = authC.user.value?.email;
                            await _repo.takeToken(slotName: slot, uid: uid, userEmail: email);
                            Get.snackbar('Queue', 'Token taken for $slot');
                          },
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
