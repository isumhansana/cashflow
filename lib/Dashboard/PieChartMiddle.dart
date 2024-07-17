import 'package:flutter/material.dart';

class PieChartMiddle extends StatefulWidget {
  const PieChartMiddle({super.key});

  @override
  State<PieChartMiddle> createState() => _PieChartMiddleState();
}

class _PieChartMiddleState extends State<PieChartMiddle> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Income: Rs.2 000 000",
              style: TextStyle(
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
        SizedBox(height: 7),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Expense: Rs.1 000 000",
              style: TextStyle(
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
        SizedBox(height: 7),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Balance: Rs.1 000 000",
              style: TextStyle(
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ],
    );
  }
}
