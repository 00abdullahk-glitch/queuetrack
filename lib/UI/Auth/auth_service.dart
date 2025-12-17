class AuthService {
  bool signedIn = false;
  String? userEmail;
  bool emailVerified = false;

  Future<void> signIn(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    signedIn = true;
    userEmail = email;
    emailVerified = true;
  }

  Future<void> signUp(String name, String email, String pw, String phone) async {
    await Future.delayed(const Duration(seconds: 1));
    signedIn = true;
    userEmail = email;
    emailVerified = false;
  }

  Future<void> changePassword(String oldPw, String newPw) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> resetPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> signOut() async {
    signedIn = false;
    userEmail = null;
    emailVerified = false;
  }
}

final auth = AuthService();