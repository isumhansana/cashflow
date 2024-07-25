import 'package:cashflow/Dashboard/IncomeExpense.dart';
import 'package:flutter/material.dart';

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
  double income = 20000;
  double expense = 10000;

  @override
  void initState() {
    super.initState();
    year = widget.year;
    month = widget.month;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => IncomeExpense(year, month))),
      child: Column(
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
      ),
    );
  }
}
