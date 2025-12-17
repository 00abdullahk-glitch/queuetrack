import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:semesterproject/AuthScaffold.dart';
import 'package:semesterproject/providers/Rounded_Button.dart';
import 'package:get/get.dart';
import 'package:semesterproject/viewmodels/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();

    return AuthScaffold(
      title: "Login",
      child: Form(
        key: _form,
        child: Column(
          children: [
            TextFormField(
              controller: _emailCtrl,
              decoration: const InputDecoration(labelText: "Email"),
              validator: (v) => v!.isEmpty ? "Enter email" : null,
            ),

            TextFormField(
              controller: _pwCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
              validator: (v) => v!.isEmpty ? "Enter password" : null,
            ),

            const SizedBox(height: 20),

            Obx(() => authC.loading.value
                ? const CircularProgressIndicator()
                : RoundedButton(
                    text: "Login",
                    onPressed: () async {
                      if (!_form.currentState!.validate()) return;

                      try {
                        final ok = await authC.signIn(_emailCtrl.text.trim(), _pwCtrl.text);
                        if (!ok) return; // controller already showed error

                        await authC.reloadUser();
                        if (authC.emailVerified) {
                          // Take verified users to the dashboard so they can access queue features
                          Get.offAllNamed('/dashboard');
                        } else {
                          Get.offAllNamed('/verify');
                        }
                      } catch (e) {
                        Get.log('Login_page unexpected: $e');
                        Get.snackbar('Login', 'Unexpected error');
                      }
                    },
                  )),

            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Get.toNamed('/signup'),
              child: const Text('Create account'),
            ),
            TextButton(
              onPressed: () => Get.toNamed('/reset'),
              child: const Text('Forgot password?'),
            ),
          ],
        ),
      ),
    );
  }
}