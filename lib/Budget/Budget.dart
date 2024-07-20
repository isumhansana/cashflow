import 'package:cashflow/Categories/Categories.dart';
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
  final catList = FinalCategories().catList;

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
        onPressed: () => showDialog(
            context: context,
            builder: (_) => const NewBudgetDialog()
        ),
        backgroundColor: const Color(0xFF235AE8),
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Padding(
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
                  children: catList.asMap().entries.map((mapEntry){
                    final budget = mapEntry.value.budget;
                    if(budget==null){
                      return const SizedBox();
                    }else {
                      return Column(
                        children: [
                          Container(
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
                                        "Rs. $budget",
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
}
