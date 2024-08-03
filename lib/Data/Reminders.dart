import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Reminders {
  final String title;
  final double amount;
  final String repeat;
  final bool paid;

  Reminders({
    required this.title,
    required this.amount,
    required this.repeat,
    required this.paid
  });
}

class ReminderList {
  var reList = <Reminders>[];
  final _user = FirebaseAuth.instance.currentUser;

  Future<List<Reminders>> getReminders() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection("entries").doc(_user!.uid).collection("Reminder").get();
    snapshot.docs.map((entry) {
      reList.add(
          Reminders(
              title: entry['title'],
              amount: double.parse(entry['amount']),
              repeat: entry['repeat'],
              paid: entry['paid']
          )
      );
    }).toList();
    return reList;
  }
}