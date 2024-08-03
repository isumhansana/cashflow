import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Data/Reminders.dart';
import 'isPaidDialog.dart';

class PaidReminders extends StatefulWidget {
  const PaidReminders({super.key});

  @override
  State<PaidReminders> createState() => _PaidRemindersState();
}

class _PaidRemindersState extends State<PaidReminders> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Paid Reminder",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFF102C40),
          leading: IconButton(
              onPressed: (){
                Navigator.pushNamedAndRemoveUntil(context, '/reminder', (route) => false);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              )
          ),
        ),
        body: FutureBuilder(
            future: ReminderList().getReminders(),
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.waiting
                  ? const Center(child: CupertinoActivityIndicator())
                  : Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Your Paid Reminders",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25
                                ),
                              ),
                              const SizedBox(height: 20),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: snapshot.data!.asMap().entries.map((mapEntry){
                                  return mapEntry.value.paid == false
                                      ? const SizedBox()
                                      : Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () => _changePaidStatus(mapEntry.value.title, mapEntry.value.amount, mapEntry.value.repeat, mapEntry.value.paid),
                                        onLongPress: () => _delete(mapEntry.value.title, mapEntry.value.amount, mapEntry.value.repeat),
                                        child: Container(
                                          height: 80,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black
                                              ),
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(10)
                                              )
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      mapEntry.value.title,
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 20
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Rs. ${mapEntry.value.amount.toInt()}",
                                                          style: const TextStyle(
                                                              fontSize: 20
                                                          ),
                                                        ),
                                                        Text(
                                                          "  /${mapEntry.value.repeat == "Monthly" ? "mo" : "yr"}",
                                                          style: const TextStyle(
                                                              fontSize: 14
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ]
                        ),
                      ),
                    );
            }
        ),
      ),
    );
  }

  Future<void> _delete(String title, double amount, String repeat) async {
    final user = FirebaseAuth.instance.currentUser;
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection("entries").doc(user!.uid).collection("Reminder").get();
    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Delete Reminder"),
          content: Text(
            "Are you sure you want to delete $title Reminder?",
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Cancel",
                  style: TextStyle(fontSize: 14),
                )
            ),
            TextButton(
                onPressed: (){
                  for(var entry in snapshot.docs){
                    if(title == entry['title'] && amount == double.parse(entry['amount']) && repeat == entry['repeat']){
                      FirebaseFirestore.instance.collection("entries").doc(user.uid).collection("Reminder").doc(entry.id).delete();
                      break;
                    }
                  }
                  Navigator.pop(context);
                },
                child: const Text(
                  "Delete",
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 14
                  ),
                )
            )
          ],
        )
    );
    setState(() {});
  }

  _changePaidStatus(String title, double amount, String repeat, bool isPaid) async {
    await showDialog(
        context: context,
        builder: (_) => IsPaid(title, amount, repeat, isPaid)
    );
    setState(() {});
  }
}
