import 'package:flutter/material.dart';
import 'package:semesterproject/AuthScaffold.dart';
import 'package:semesterproject/providers/Rounded_Button.dart';
import 'package:get/get.dart';
import 'package:semesterproject/viewmodels/auth_controller.dart';
import 'package:semesterproject/providers/queue_repo.dart';
import 'package:semesterproject/models/queue_token.dart';


class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final authC = Get.find<AuthController>();
    // Colors
    const kPrimary = Colors.blue;
    const kAccent = Colors.deepPurple;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: kPrimary,
      ),

      drawer: Drawer(
        child: Column(
          children: [
            Obx(() => UserAccountsDrawerHeader(
              accountName: const Text('User'),
              accountEmail: Text(authC.userEmail ?? ''),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: kPrimary),
              ),
              decoration: const BoxDecoration(color: kPrimary),
            )),

            ListTile(
              leading: const Icon(Icons.queue),
              title: const Text('My Token'),
              onTap: () => Navigator.pushNamed(context, '/queue'),
            ),

            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Universal Queue'),
              onTap: () => Navigator.pushNamed(context, '/uqueue'),
            ),

            ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: const Text('Owner (manager)'),
              onTap: () => Navigator.pushNamed(context, '/owner/login'),
            ),

            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Change Password'),
              onTap: () => Get.toNamed('/change'),
            ),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                await authC.signOut();
                Get.offAllNamed('/login');
              },
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome back,', style: TextStyle(color: Colors.grey[700])),
            const SizedBox(height: 4),

            Obx(() => Text(
                authC.userEmail ?? 'Guest',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),

            const SizedBox(height: 18),

            // Main Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Current Queue'),
                        SizedBox(height: 6),
                        Text(
                          'Car Service',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    RoundedButton(
                      text: 'Take Token',
                      onPressed: () => Navigator.pushNamed(context, '/queue'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            Expanded(
              child: StreamBuilder<List<QueueToken>>(
                stream: QueueRepo().streamTokens(),
                builder: (context, snap) {
                  final tokens = snap.data ?? [];
                  return ListView.builder(
                    itemCount: 5,
                    itemBuilder: (_, i) {
                      final slot = 'Slot ${i + 1}';
                      final occupied = tokens.any((t) => t.slotName == slot);
                      return QueuePreviewCard(
                        slotName: slot,
                        eta: occupied ? 'Taken' : '${10 + (i * 5)} mins',
                        color: kAccent,
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

class QueuePreviewCard extends StatelessWidget {
  final String slotName;
  final String eta;
  final Color color;

  const QueuePreviewCard({
    super.key,
    required this.slotName,
    required this.eta,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: const Icon(Icons.timer, color: Colors.white),
        ),
        title: Text(slotName),
        subtitle: Text('ETA: $eta'),
        trailing: RoundedButton(
          text: 'View',
          filled: false,
          onPressed: () => Navigator.pushNamed(context, '/queue'),
        ),
      ),
    );
  }
}
