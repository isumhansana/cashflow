import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cashflow/Authentication/login.dart';
import 'package:cashflow/Authentication/registerForm.dart';
import 'package:cashflow/Budget/Budget.dart';
import 'package:cashflow/Dashboard/Dashboard.dart';
import 'package:cashflow/Data/Reminders.dart';
import 'package:cashflow/Profile/ProfileScreen.dart';
import 'package:cashflow/Reminder/PaidReminders.dart';
import 'package:cashflow/Reminder/Reminder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:workmanager/workmanager.dart';

import 'Authentication/ForgotPassword.dart';

void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    int index = 0;
    List<Reminders> reminderList = await ReminderList().getReminders();
    if(taskName == "Monthly") {
      for(var reminder in reminderList) {
        index += 1;
        if(reminder.repeat == "Monthly" && !reminder.paid){
          await AwesomeNotifications().createNotification(
              content: NotificationContent(
                  id: index,
                  channelKey: 'monthly',
                  title: reminder.title,
                  body: "You have to do a ${reminder.repeat} payment of Rs. ${reminder.amount}"
              )
          );
        }
      }
    } else {
      for(var reminder in reminderList) {
        index += 1;
        if(reminder.repeat == "Yearly" && !reminder.paid){
          await AwesomeNotifications().createNotification(
              content: NotificationContent(
                  id: index,
                  channelKey: 'yearly',
                  title: reminder.title,
                  body: "You have to do a ${reminder.repeat} payment of Rs. ${reminder.amount}"
              )
          );
        }
      }
    }
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  await Workmanager().initialize(callbackDispatcher);
  AwesomeNotifications().initialize(
      'assets/imgs/cashflow_logo.png',
      [
        NotificationChannel(
          channelKey: 'monthly',
          channelName: 'CashFlow Monthly',
          channelDescription: 'CashFlow Monthly Channel',
          playSound: true
        ),
        NotificationChannel(
            channelKey: 'yearly',
            channelName: 'CashFlow Yearly',
            channelDescription: 'CashFlow Yearly Channel',
            playSound: true
        )
      ]
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
    Workmanager().registerPeriodicTask(
        "monthlyReminder",
        "Monthly",
        constraints: Constraints(networkType: NetworkType.connected),
        frequency: const Duration(days: 10),
        initialDelay: const Duration(days: 1)
    );

    Workmanager().registerPeriodicTask(
        "yearlyReminder",
        "Yearly",
        constraints: Constraints(networkType: NetworkType.connected),
        frequency: const Duration(days: 90),
        initialDelay: const Duration(days: 1)
    );

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
        '/paidReminder': (context) => const PaidReminders(),
        '/profile' : (context) => const ProfileScreen(),
        '/forgotPassword': (context) => const ForgotPassword(),
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
