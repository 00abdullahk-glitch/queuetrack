import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // reactive user
  final Rxn<User> user = Rxn<User>();
  final RxBool loading = false.obs;

  @override
  void onInit() {
    // bind to auth state changes
    user.bindStream(_auth.authStateChanges());
    super.onInit();
  }

  bool get isSignedIn => user.value != null;
  String? get userEmail => user.value?.email;
  bool get emailVerified => user.value?.emailVerified ?? false;

  Future<bool> signIn(String email, String password) async {
    try {
      loading.value = true;
      final res = await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.log('signIn success: ${res.user?.uid}');
      return true;
    } on FirebaseAuthException catch (e) {
      Get.log('signIn error: ${e.code} ${e.message}');
      Get.snackbar('Login Error', '${e.code}: ${e.message}');
      return false;
    } catch (e) {
      Get.log('signIn unexpected error: $e');
      Get.snackbar('Login Error', 'Unexpected error');
      return false;
    } finally {
      loading.value = false;
    }
  }

  Future<bool> signUp(String name, String email, String password, String phone) async {
    try {
      loading.value = true;
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      Get.log('signUp success: ${cred.user?.uid}');
      await cred.user?.updateDisplayName(name);
      await sendEmailVerification();
      return true;
    } on FirebaseAuthException catch (e) {
      Get.log('signUp error: ${e.code} ${e.message}');
      Get.snackbar('Signup Error', '${e.code}: ${e.message}');
      return false;
    } catch (e) {
      Get.log('signUp unexpected error: $e');
      Get.snackbar('Signup Error', 'Unexpected error');
      return false;
    } finally {
      loading.value = false;
    }
  }

  Future<bool> sendEmailVerification() async {
    try {
      final u = _auth.currentUser;
      if (u != null && !u.emailVerified) {
        await u.sendEmailVerification();
        Get.snackbar('Verification', 'Verification email sent');
        return true;
      }
      return false;
    } catch (e) {
      Get.log('sendEmailVerification error: $e');
      Get.snackbar('Verification Error', 'Could not send verification');
      return false;
    }
  }

  Future<void> reloadUser() async {
    await _auth.currentUser?.reload();
    user.value = _auth.currentUser;
  }

  Future<bool> resetPassword(String email) async {
    try {
      loading.value = true;
      await _auth.sendPasswordResetEmail(email: email);
      Get.log('resetPassword: email sent to $email');
      return true;
    } on FirebaseAuthException catch (e) {
      Get.log('resetPassword error: ${e.code} ${e.message}');
      Get.snackbar('Reset Error', '${e.code}: ${e.message}');
      return false;
    } catch (e) {
      Get.log('resetPassword unexpected error: $e');
      Get.snackbar('Reset Error', 'Unexpected error');
      return false;
    } finally {
      loading.value = false;
    }
  }

  Future<bool> changePassword(String oldPw, String newPw) async {
    final u = _auth.currentUser;
    if (u == null) {
      Get.snackbar('Change Password Error', 'No user signed in');
      return false;
    }

    try {
      loading.value = true;
      final cred = EmailAuthProvider.credential(email: u.email!, password: oldPw);
      await u.reauthenticateWithCredential(cred);
      await u.updatePassword(newPw);
      Get.snackbar('Password', 'Password changed successfully');
      return true;
    } on FirebaseAuthException catch (e) {
      Get.log('changePassword error: ${e.code} ${e.message}');
      Get.snackbar('Change Password Error', '${e.code}: ${e.message}');
      return false;
    } catch (e) {
      Get.log('changePassword unexpected error: $e');
      Get.snackbar('Change Password Error', 'Unexpected error');
      return false;
    } finally {
      loading.value = false;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
