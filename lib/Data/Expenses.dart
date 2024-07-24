import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Expenses {
  final double amount;
  final String description;
  final String category;
  final Timestamp date;

  Expenses({
    required this.amount,
    required this.description,
    required this.category,
    required this.date
  });
}

class ExpenseList {
  var exList = <Expenses>[];
  final _user = FirebaseAuth.instance.currentUser;

  Future<List<Expenses>> getExpenses() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection("entries").doc(_user!.uid).collection("Expense").get();
    snapshot.docs.map((entry) {
      exList.add(
        Expenses(
            amount: double.parse(entry['amount']),
            description: entry['description'],
            category: entry['category'],
            date: entry['date']
        )
      );
    }).toList();
    return exList;
  }
}