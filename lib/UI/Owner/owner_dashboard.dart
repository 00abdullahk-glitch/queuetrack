import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesterproject/providers/queue_repo.dart';
import 'package:semesterproject/models/queue_token.dart';

class OwnerDashboard extends StatefulWidget {
  const OwnerDashboard({super.key});

  @override
  State<OwnerDashboard> createState() => _OwnerDashboardState();
}

class _OwnerDashboardState extends State<OwnerDashboard> {
  final _repo = QueueRepo();
  QueueToken? _current;

  Future<void> _callNext() async {
    final t = await _repo.callNext(calledBy: 'owner');
    if (t == null) {
      Get.snackbar('Queue', 'No waiting tokens');
    } else {
      setState(() => _current = t);
      Get.snackbar('Queue', 'Called token #${t.number}');
    }
  }

  Future<void> _finishCurrent() async {
    if (_current == null) return;
    await _repo.finishToken(_current!.id);
    Get.snackbar('Queue', 'Finished token #${_current!.number}');
    setState(() => _current = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Owner Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Current called', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _current == null
                        ? const Text('No token called')
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Number: #${_current?.number ?? "-"}'),
                              const SizedBox(height: 6),
                              Text('User: ${_current?.userEmail ?? _current?.uid ?? "-"}'),
                            ],
                          ),
                    Row(
                      children: [
                        ElevatedButton(onPressed: _callNext, child: const Text('Call Next')),
                        const SizedBox(width: 8),
                        ElevatedButton(onPressed: _finishCurrent, child: const Text('Finish')),
                      ],
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            const Text('Queue (waiting)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            Expanded(
              child: StreamBuilder<List<QueueToken>>(
                stream: _repo.streamAllTokens(status: 'waiting'),
                builder: (context, snap) {
                  final tokens = snap.data ?? [];
                  if (tokens.isEmpty) return const Center(child: Text('No waiting tokens'));

                  return ListView.builder(
                    itemCount: tokens.length,
                    itemBuilder: (_, i) {
                      final t = tokens[i];
                      return ListTile(
                        leading: CircleAvatar(child: Text('${t.number ?? i + 1}')),
                        title: Text('#${t.number ?? "-"} — ${t.userEmail ?? t.uid ?? "Unknown"}'),
                        subtitle: Text('Created: ${t.createdAt?.toDate().toLocal().toString().split('.')[0] ?? "-"}'),
                        trailing: TextButton(
                          child: const Text('Call'),
                          onPressed: () async {
                            final called = await _repo.callNext(calledBy: 'owner');
                            if (called != null) {
                              setState(() => _current = called);
                              Get.snackbar('Queue', 'Called token #${called.number}');
                            }
                          },
                        ),
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
