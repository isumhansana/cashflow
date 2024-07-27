import 'package:cashflow/Dashboard/IncomeExpense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Data/Expenses.dart';
import '../Data/Incomes.dart';

class PieChartMiddle extends StatefulWidget {
  final int year;
  final int month;
  const PieChartMiddle(this.year, this.month, {super.key});

  @override
  State<PieChartMiddle> createState() => _PieChartMiddleState();
}

class _PieChartMiddleState extends State<PieChartMiddle> {
  int year = 0;
  int month = 0;
  double income = 0;
  double expense = 0;

  @override
  void initState() {
    super.initState();
    year = widget.year;
    month = widget.month;
    _getTotalExpense();
    _getTotalIncome();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => IncomeExpense(year, month))),
      child: FutureBuilder(
        future: ExpenseList().getExpenses(),
        builder: (context, snapshot) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Income: Rs.$income",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 7),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Expense: Rs.$expense",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 7),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Balance: Rs.${income - expense}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            ],
          );
        }
      ),
    );
  }
  _getTotalExpense() async {
    var exList = await ExpenseList().getExpenses();
    setState(() {
        exList.asMap().entries.map((mapEntry) {
          if(int.parse(DateFormat("yyyy").format(mapEntry.value.date.toDate())) == year && int.parse(DateFormat("MM").format(mapEntry.value.date.toDate())) == month) {
            expense = expense + mapEntry.value.amount;
          }
        }).toList();
    });
  }

  _getTotalIncome() async {
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
