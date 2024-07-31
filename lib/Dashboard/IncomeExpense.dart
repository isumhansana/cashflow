import 'package:cashflow/Data/Expenses.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Categories/Categories.dart';
import '../Data/Incomes.dart';

class IncomeExpense extends StatefulWidget {
  final int year;
  final int month;
  final String? title;
  const IncomeExpense(this.year, this.month, this.title, {super.key});

  @override
  State<IncomeExpense> createState() => _IncomeExpenseState();
}

class _IncomeExpenseState extends State<IncomeExpense> {
  int year = 0;
  int month = 0;
  double income = 0;
  String? title;
  var exList = <Expenses>[];

  @override
  void initState() {
    super.initState();
    year = widget.year;
    month = widget.month;
    title = widget.title;
    _getTotalIncome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: (){
                Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              )
          ),
          title: const Text(
            "Incomes & Expenses",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFF102C40),
        ),
        body: FutureBuilder(
          future: FinalCategories().getData(year.toInt(), month.toInt()),
          builder: (context, dataSnapshot) {
            return dataSnapshot.connectionState == ConnectionState.waiting
                ? const Center(child: CupertinoActivityIndicator())
                : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
                    child: Column(
                        children: [
                          income==0
                              ? const SizedBox()
                              : ExpansionTile(
                                  title: const Text(
                                    "Incomes",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  shape: const Border(),
                                  trailing: Text(
                                    "Rs. ${income.toInt()}",
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color: Color(0xFF03AB00),
                                        fontWeight: FontWeight.normal
                                    ),
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                                      child: FutureBuilder(
                                          future: IncomeList().getIncomes(),
                                          builder: (context, snapshot) {
                                            return snapshot.connectionState == ConnectionState.waiting
                                                ? const SizedBox()
                                                : Column(
                                              children: snapshot.data!.asMap().entries.map((mapEntry) {
                                                return Column(
                                                  children: [
                                                    int.parse(DateFormat("yyyy").format(mapEntry.value.date.toDate())) == year && int.parse(DateFormat("MM").format(mapEntry.value.date.toDate())) == month
                                                        ? GestureDetector(
                                                          onLongPress: () => _delete(mapEntry.value.description, mapEntry.value.amount, "Income", mapEntry.value.date),
                                                          child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                  Text(
                                                                    "Rs. ${mapEntry.value.amount.toInt()}   ${mapEntry.value.description}",
                                                                    style: const TextStyle(fontSize: 16),
                                                                  ),
                                                                  Text(
                                                                    DateFormat("dd MMM").format(
                                                                        mapEntry.value.date.toDate()
                                                                    ),
                                                                    style: const TextStyle(fontSize: 16),
                                                                  ),
                                                                ]
                                                            ),
                                                        ) : const SizedBox()
                                                        ],
                                                );
                                              }).toList(),
                                            );
                                          }),
                                    ),
                                  ],
                                ),
                          FutureBuilder(
                              future: ExpenseList().getExpenses(),
                              builder: (context, snapshot) {
                                return snapshot.connectionState == ConnectionState.waiting
                                    ? const SizedBox()
                                    : Column(
                                      children: dataSnapshot.data!.asMap().entries.map((dataMapEntry){
                                        return dataMapEntry.value.value==0
                                            ? const SizedBox()
                                            : ExpansionTile(
                                                title: Text(
                                                  dataMapEntry.value.title,
                                                  style: const TextStyle(fontSize: 20),
                                                ),
                                                shape: const Border(),
                                                trailing: Text(
                                                  "Rs. ${dataMapEntry.value.value.toInt()}",
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      color: Color(0xFFFF3F3F),
                                                      fontWeight: FontWeight.normal
                                                  ),
                                                ),
                                                initiallyExpanded: dataMapEntry.value.title == title ? true : false,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                                    child: Column(
                                                      children: snapshot.data!.asMap().entries.map((mapEntry) {
                                                        return Column(
                                                          children: [
                                                            int.parse(DateFormat("yyyy").format(mapEntry.value.date.toDate())) == year && int.parse(DateFormat("MM").format(mapEntry.value.date.toDate())) == month && dataMapEntry.value.title == mapEntry.value.category
                                                                ? GestureDetector(
                                                                  onLongPress: () => _delete(mapEntry.value.description, mapEntry.value.amount, mapEntry.value.category, mapEntry.value.date),
                                                                  child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      "Rs. ${mapEntry.value.amount.toInt()}   ${mapEntry.value.description}",
                                                                      style: const TextStyle(fontSize: 16),
                                                                    ),
                                                                    Text(
                                                                      DateFormat("dd MMM").format(
                                                                          mapEntry.value.date.toDate()
                                                                      ),
                                                                      style: const TextStyle(fontSize: 16),
                                                                    ),
                                                                  ]
                                                                                                                              ),
                                                                ) : const SizedBox()
                                                          ],
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ],
                                        );
                                      }).toList(),
                                    );
                              }),
                        ],
                                ),
                  ),
                );
          }
        ));
  }

  Future<void> _delete(String description, double amount, String category, Timestamp date) async {
    final user = FirebaseAuth.instance.currentUser;
    QuerySnapshot<Map<String, dynamic>> expenseSnapshot = await FirebaseFirestore.instance.collection("entries").doc(user!.uid).collection("Expense").get();
    QuerySnapshot<Map<String, dynamic>> incomeSnapshot = await FirebaseFirestore.instance.collection("entries").doc(user.uid).collection("Income").get();
    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Delete Entry"),
          content: Text(
            "Are you sure you want to delete Rs. ${amount.toInt()} $description?",
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
                  if(category == 'Income') {
                    incomeSnapshot.docs.map((entry){
                      if(description == entry['description'] && amount.toInt().toString() == entry['amount'] && date == entry['date']){
                        FirebaseFirestore.instance.collection("entries").doc(user.uid).collection("Income").doc(entry.id).delete();
                      }
                    }).toList();
                  } else {
                    expenseSnapshot.docs.map((entry){
                      if(description == entry['description'] && amount.toInt().toString() == entry['amount'] && date == entry['date'] && category == entry['category']){
                        FirebaseFirestore.instance.collection("entries").doc(user.uid).collection("Expense").doc(entry.id).delete();
                      }
                    }).toList();
                  }
                  Navigator.pop(context);
                  setState(() {
                    _getTotalIncome();
                  });
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
  }
  _getTotalIncome() async {
    income = 0;
    var inList = await IncomeList().getIncomes();
    setState(() {
      inList.asMap().entries.map((mapEntry) {
        if(int.parse(DateFormat("yyyy").format(mapEntry.value.date.toDate())) == year && int.parse(DateFormat("MM").format(mapEntry.value.date.toDate())) == month) {
          income = income + mapEntry.value.amount;
        }
      }).toList();
    });
  }
}
