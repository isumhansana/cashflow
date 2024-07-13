import 'package:cashflow/Authentication/login.dart';
import 'package:cashflow/Authentication/registerForm.dart';
import 'package:cashflow/Profile/ProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "CashFlow",
      home: const Login(),
      routes: {
        '/login' : (context) => const Login(),
        '/register' : (context) => const Register(),
        '/profile' : (context) => const ProfileScreen()
      },
    );
  }
}
