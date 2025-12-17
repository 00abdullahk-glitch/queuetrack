import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OwnerLogin extends StatefulWidget {
  const OwnerLogin({super.key});

  @override
  State<OwnerLogin> createState() => _OwnerLoginState();
}

class _OwnerLoginState extends State<OwnerLogin> {
  final _formKey = GlobalKey<FormState>();
  final _userCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();

  // Hard-coded credentials (change later if needed)
  static const ownerUser = 'owner@example.com';
  static const ownerPass = 'ownerpass';

  bool _loading = false;

  void _login() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    final u = _userCtrl.text.trim();
    final p = _pwCtrl.text;

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() => _loading = false);
      if (u == ownerUser && p == ownerPass) {
        Get.offAllNamed('/owner/dashboard');
      } else {
        Get.snackbar('Login failed', 'Invalid owner credentials');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Owner login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _userCtrl,
                decoration: const InputDecoration(labelText: 'Username (email)'),
                validator: (v) => v == null || v.isEmpty ? 'Enter username' : null,
              ),
              TextFormField(
                controller: _pwCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (v) => v == null || v.isEmpty ? 'Enter password' : null,
              ),
              const SizedBox(height: 20),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(onPressed: _login, child: const Text('Login')),
            ],
          ),
        ),
      ),
    );
  }
}
