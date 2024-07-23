import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Expenses {
  final double amount;
  final String description;
  final String category;
  final DateTime date;

  Expenses({
    required this.amount,
    required this.description,
    required this.category,
    required this.date
  });

  Expenses.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : amount = snapshot['amount'],
        description = snapshot['description'],
        category = snapshot['category'],
        date = snapshot['date'];
}

class ExpenseList {
  List<Expenses> exList = [];
  final _user = FirebaseAuth.instance.currentUser;

  getExpenses() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection("entries").doc(_user!.uid).collection("Expense").get();
    final data = snapshot.docs.map((entry) {
      return Expenses(amount: double.parse(entry['amount']), description: entry['description'], category: entry['category'], date: entry['date']);
    });
    exList.add(Expenses(amount: 5000, description: 'description', category: 'category', date: DateTime.now()));
  }
}