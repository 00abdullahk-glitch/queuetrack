import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:semesterproject/AuthScaffold.dart';
import 'package:semesterproject/providers/Rounded_Button.dart';
import 'package:get/get.dart';
import 'package:semesterproject/viewmodels/auth_controller.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _pw = TextEditingController();
  final _phone = TextEditingController();

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();

    return AuthScaffold(
      title: 'Create account',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(controller: _name, decoration: const InputDecoration(labelText: 'Full name')),
            TextFormField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
            TextFormField(controller: _phone, decoration: const InputDecoration(labelText: 'Phone')),
            TextFormField(controller: _pw, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
            const SizedBox(height: 20),

            Obx(() => authC.loading.value
                ? const CircularProgressIndicator()
                : RoundedButton(
                    text: "Sign Up",
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;

                      try {
                        final ok = await authC.signUp(
                          _name.text.trim(),
                          _email.text.trim(),
                          _pw.text,
                          _phone.text.trim(),
                        );

                        if (ok) {
                          Get.offAllNamed('/verify');
                        }
                      } catch (e) {
                        Get.log('signup_page unexpected: $e');
                        Get.snackbar('Signup', 'Unexpected error');
                      }
                    },
                  )),
          ],
        ),
      ),
    );
  }
}
