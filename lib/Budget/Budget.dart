import 'package:cashflow/Categories/Categories.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../NavBar.dart';
import 'NewBudgetDialog.dart';

class Budget extends StatefulWidget {
  const Budget({super.key});

  @override
  State<Budget> createState() => _BudgetState();
}

class _BudgetState extends State<Budget> {
  int myIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Budgets",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF102C40),
      ),
      bottomNavigationBar: NavBar(myIndex),
      floatingActionButton: FloatingActionButton(
        onPressed: _floatingButton,
        backgroundColor: const Color(0xFF235AE8),
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: FutureBuilder(
        future: FinalCategories().getData(0, 0),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? const Center(child: CupertinoActivityIndicator())
              : Scrollbar(
                child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Edit Your Budgets",
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
                                final budget = mapEntry.value.budget;
                                if(budget==null){
                                  return const SizedBox();
                                }else {
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () => _newBudget(mapEntry.value.title, budget.toInt().toString()),
                                        onLongPress: () => _delete(mapEntry.value.title),
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
                                                    Text(
                                                      "Rs. ${budget.toInt()}",
                                                      style: const TextStyle(
                                                          fontSize: 20
                                                      ),
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
                                }
                              }).toList(),
                            ),
                          ]
                      ),
                    ),
                          ),
              );
        }
      ),
    );
  }

  _floatingButton() {
    _newBudget(null, "");
  }

  Future<void> _newBudget(String? category, String budget) async {
    await showDialog(
        context: context,
        builder: (_) => NewBudgetDialog(category, budget)
    );
    setState(() {});
  }

  Future<void> _delete(String title) async {
    final user = FirebaseAuth.instance.currentUser;
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection("entries").doc(user!.uid).collection("Budget").get();
    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Delete Budget"),
          content: Text(
              "Are you sure you want to delete $title budget?",
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
                  snapshot.docs.map((entry){
                    if(title == entry['category']){
                      FirebaseFirestore.instance.collection("entries").doc(user.uid).collection("Budget").doc(entry.id).delete();
                    }
                  }).toList();
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
}
