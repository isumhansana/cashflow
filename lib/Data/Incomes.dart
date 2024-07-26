import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Incomes {
  final double amount;
  final String description;
  final DateTime date;

  Incomes({
    required this.amount,
    required this.description,
    required this.date
  });
}

class IncomeList {
  var inList = <Incomes>[];
  final _user = FirebaseAuth.instance.currentUser;

  Future<List<Incomes>> getIncomes() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection("entries").doc(_user!.uid).collection("Income").get();
    snapshot.docs.map((entry) {
      inList.add(
          Incomes(
              amount: double.parse(entry['amount']),
              description: entry['description'],
              date: entry['date']
          )
      );
    }).toList();
    return inList;
  }
}