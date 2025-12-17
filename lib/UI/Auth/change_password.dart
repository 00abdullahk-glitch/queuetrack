import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:semesterproject/AuthScaffold.dart';
import 'package:semesterproject/providers/Rounded_Button.dart';
import 'package:get/get.dart';
import 'package:semesterproject/viewmodels/auth_controller.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final oldPw = TextEditingController();
  final newPw = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: oldPw,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Old Password"),
                validator: (v) => v!.isEmpty ? "Enter old password" : null,
              ),

              TextFormField(
                controller: newPw,
                obscureText: true,
                decoration: const InputDecoration(labelText: "New Password"),
                validator: (v) => v!.isEmpty ? "Enter new password" : null,
              ),

              const SizedBox(height: 30),

              Obx(() => authC.loading.value
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;

                        final messenger = ScaffoldMessenger.of(context);

                        try {
                          final ok = await authC.changePassword(oldPw.text, newPw.text);
                          if (ok) {
                            messenger.showSnackBar(
                              const SnackBar(content: Text('Password changed successfully')),
                            );
                          }
                        } catch (e) {
                          Get.log('change_password unexpected: $e');
                        }
                      },
                      child: const Text("Change Password"),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
