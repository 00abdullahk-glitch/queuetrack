import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:semesterproject/UI/Auth/Home_page.dart';
import 'package:semesterproject/UI/Auth/Login_page.dart';
import 'package:semesterproject/UI/Auth/signup_page.dart';
import 'package:semesterproject/UI/Auth/reset_password.dart';
import 'package:semesterproject/UI/Auth/verification_page.dart';
import 'package:semesterproject/UI/Auth/change_password.dart';
import 'package:semesterproject/UI/queue_page.dart';
import 'package:semesterproject/UI/universal_queue_page.dart';
import 'package:semesterproject/UI/Owner/owner_login.dart';
import 'package:semesterproject/UI/Owner/owner_dashboard.dart';
import 'package:semesterproject/Dash_Board.dart';
import 'package:semesterproject/UI/Auth/firebase_options.dart';
import 'package:semesterproject/bindings/auth_binding.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);

    Zone.current.handleUncaughtError(details.exception, details.stack ?? StackTrace.empty);
  };

  runZonedGuarded(() {

    runApp(
      GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialBinding: AuthBinding(),
        initialRoute: '/login',
        getPages: [
          GetPage(name: '/login', page: () => const LoginScreen(), binding: AuthBinding()),
          GetPage(name: '/signup', page: () => const SignupScreen()),
          GetPage(name: '/reset', page: () => const ResetPasswordScreen()),
          GetPage(name: '/verify', page: () => const VerificationScreen()),
          GetPage(name: '/change', page: () => const ChangePasswordScreen()),
          GetPage(name: '/dashboard', page: () => const DashboardScreen()),
          GetPage(name: '/home', page: () => const HomePage()),
          GetPage(name: '/queue', page: () => QueuePage()),
          GetPage(name: '/uqueue', page: () => const UniversalQueuePage()),
          GetPage(name: '/owner/login', page: () => const OwnerLogin()),
          GetPage(name: '/owner/dashboard', page: () => const OwnerDashboard()),
        ],
      ),
    );
  }, (error, stack) {
    
    debugPrint('Uncaught zone error: $error');
    // Replace the app with an error widget by scheduling a microtask
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ErrorWidget.builder = (FlutterErrorDetails details) {
        return Scaffold(
          appBar: AppBar(title: const Text('App error')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(child: Text(details.toString())),
          ),
        );
      };
    });
  });
}
