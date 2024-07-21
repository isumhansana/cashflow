import 'package:cashflow/Authentication/login.dart';
import 'package:cashflow/Authentication/registerForm.dart';
import 'package:cashflow/Budget/Budget.dart';
import 'package:cashflow/Dashboard/Dashboard.dart';
import 'package:cashflow/Dashboard/IncomeExpense.dart';
import 'package:cashflow/Profile/ProfileScreen.dart';
import 'package:cashflow/Reminder/Reminder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var isLoggedIn = false;

  @override
  void initState() {
    _checkLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "CashFlow",
      home: isLoggedIn ? const Dashboard() : const Login(),
      routes: {
        '/login' : (context) => const Login(),
        '/register' : (context) => const Register(),
        '/dashboard': (context) => const Dashboard(),
        '/budget': (context) => const Budget(),
        '/reminder': (context) => const Reminder(),
        '/profile' : (context) => const ProfileScreen(),
        '/incomes&expenses': (context) => const IncomeExpense()
      },
    );
  }

  _checkLoggedIn() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if(user != null && mounted) {
        setState(() {
          isLoggedIn = true;
        });
      }
    });
  }
}
