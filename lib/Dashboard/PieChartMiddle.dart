import 'package:flutter/material.dart';

class PieChartMiddle extends StatefulWidget {
  const PieChartMiddle({super.key});

  @override
  State<PieChartMiddle> createState() => _PieChartMiddleState();
}

class _PieChartMiddleState extends State<PieChartMiddle> {
  double income = 20000;
  double expense = 10000;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/incomes&expenses'),
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
