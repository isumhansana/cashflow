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
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';

import 'Authentication/ForgotPassword.dart';
import 'firebase_options.dart';
import 'network_error.dart';

@pragma('vm:entry-point')
void callbackDispatcher() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
  Workmanager().executeTask((taskName, inputData) async {
    if(FirebaseAuth.instance.currentUser != null){
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
    } else {
      return Future.value(false);
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  await Workmanager().initialize(callbackDispatcher);
  await Permission.notification.request();
  AwesomeNotifications().initialize(
      'resource://drawable/cashflow_logo_noti',
      [
        NotificationChannel(
          channelKey: 'monthly',
          channelName: 'Monthly Reminders',
          channelDescription: 'CashFlow Monthly Channel',
          playSound: true
        ),
        NotificationChannel(
            channelKey: 'yearly',
            channelName: 'Yearly Reminders',
            channelDescription: 'CashFlow Yearly Channel',
            playSound: true
        )
      ]
  );

  await Workmanager().registerPeriodicTask(
      "monthlyReminder",
      "Monthly",
      frequency: const Duration(days: 10),
      initialDelay: const Duration(hours: 1),
      constraints: Constraints(networkType: NetworkType.connected)
  );

  await Workmanager().registerPeriodicTask(
      "yearlyReminder",
      "Yearly",
      frequency: const Duration(days: 90),
      initialDelay: const Duration(hours: 1),
      constraints: Constraints(networkType: NetworkType.connected)
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
  var connectivityResult = false;

  @override
  void initState() {
    _checkConnectivity();
    _checkLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "CashFlow",
      home: connectivityResult
          ? (isLoggedIn ? const Dashboard() : const Login())
          : const NetworkErrorPage(),
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

  _checkConnectivity() async {
    var connectivity = await Connectivity().checkConnectivity();
    if(connectivity.contains(ConnectivityResult.mobile) || connectivity.contains(ConnectivityResult.wifi)){
      setState(() {
        connectivityResult = true;
      });
    }
  }
}
