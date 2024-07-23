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
}

class ExpenseList {
  final exList = <Expenses>[];
  final _user = FirebaseAuth.instance.currentUser;

  void getExpenses() async {

  }
}