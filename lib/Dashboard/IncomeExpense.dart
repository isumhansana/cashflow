import 'package:cashflow/Data/Expenses.dart';
import 'package:flutter/material.dart';

class IncomeExpense extends StatelessWidget {
  const IncomeExpense({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Incomes & Expenses",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF102C40),
      ),
      body: Column(
        children : ExpenseList().exList.asMap().entries.map((mapEntry){
          return Column(
            children: [
              Row(
                  children: [
                    Text(mapEntry.value.category),
                    Text(mapEntry.value.description),
                    Text(mapEntry.value.date.toString()),
                    Text(mapEntry.value.amount.toString())
                  ]
              )
            ],
          );
        }).toList(),
      )
    );
  }
}
