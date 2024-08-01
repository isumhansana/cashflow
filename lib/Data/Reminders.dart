import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Reminders {
  final String title;
  final double amount;
  final String repeat;

  Reminders({
    required this.title,
    required this.amount,
    required this.repeat,
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
              repeat: entry['repeat']
          )
      );
    }).toList();
    return reList;
  }
}