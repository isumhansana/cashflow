import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class IsPaid extends StatefulWidget {
  final String title;
  final double amount;
  final String repeat;
  final bool isPaid;
  const IsPaid(this.title, this.amount, this.repeat, this.isPaid, {super.key});

  @override
  State<IsPaid> createState() => _IsPaidState();
}

class _IsPaidState extends State<IsPaid> {
  String title = "";
  double amount = 0;
  String repeat = "";
  bool isPaid = false;

  @override
  void initState() {
    title = widget.title;
    amount = widget.amount;
    repeat = widget.repeat;
    isPaid = widget.isPaid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          "Change the Paid Status of $title Reminder",
          style: const TextStyle(fontSize: 18)
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Switch(
              value: isPaid,
              onChanged: (value) {
                setState(() {
                  isPaid = value;
                });
              }
          ),
          isPaid
              ? const Text(
                  "Paid",
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 16
                  )
                )
              : const Text(
                  "Not Paid",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 16
                  )
                )
        ],
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
            onPressed: _isPaid,
            child: const Text(
              "Save",
              style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 14
              ),
            )
        )
      ],
    );
  }

  Future<void> _isPaid() async {
    final user = FirebaseAuth.instance.currentUser;
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection("entries").doc(user!.uid).collection("Reminder").get();
    for(var entry in snapshot.docs){
      if(title == entry['title'] && amount == double.parse(entry['amount']) && repeat == entry['repeat']){
        FirebaseFirestore.instance.collection("entries").doc(user.uid).collection("Reminder").doc(entry.id).update(
            {'paid': isPaid}
        );
        break;
      }
    }
    Navigator.pop(context);
  }
}
