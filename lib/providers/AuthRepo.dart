import 'package:flutter/cupertino.dart';

class AuthRepo extends ChangeNotifier {
  bool _signedIn = false;
  String? _userEmail;
  bool _emailVerified = false;

  bool get isSignedIn => _signedIn;
  String? get userEmail => _userEmail;
  bool get emailVerified => _emailVerified;

  Future<void> signIn(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    _signedIn = true;
    _userEmail = email;
    _emailVerified = true;

    notifyListeners();
  }

  Future<void> signOut() async {
    _signedIn = false;
    _userEmail = null;
    _emailVerified = false;
    notifyListeners();
  }

  Future<void> changePassword(String oldPw, String newPw) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}