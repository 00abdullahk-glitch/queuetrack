import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesterproject/viewmodels/auth_controller.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _email = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reset Password"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(labelText: "Enter Email"),
                validator: (v) => v!.isEmpty ? "Enter your email" : null,
              ),

              const SizedBox(height: 30),

              Obx(() => authC.loading.value
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;

                        final messenger = ScaffoldMessenger.of(context);

                        try {
                          final ok = await authC.resetPassword(_email.text.trim());
                          if (ok) {
                            messenger.showSnackBar(
                              const SnackBar(content: Text("Reset email sent")),
                            );
                          }
                        } catch (e) {
                          Get.log('reset_password unexpected: $e');
                        }
                      },
                      child: const Text("Reset Password"),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
