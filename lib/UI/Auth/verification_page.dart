import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesterproject/viewmodels/auth_controller.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('A verification email has been sent to your email. Please check your inbox.'),
            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () async {
                await authC.sendEmailVerification();
              },
              child: const Text('Resend verification email'),
            ),

            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                await authC.reloadUser();
                if (authC.emailVerified) {
                  Get.offAllNamed('/home');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email not verified yet')));
                }
              },
              child: const Text('I have verified — Continue'),
            ),

            const SizedBox(height: 12),
            TextButton(
              onPressed: () async {
                await authC.signOut();
                Get.offAllNamed('/login');
              },
              child: const Text('Cancel / Sign out'),
            ),
          ],
        ),
      ),
    );
  }
}
