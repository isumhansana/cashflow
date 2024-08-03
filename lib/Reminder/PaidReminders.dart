import 'package:flutter/material.dart';

class PaidReminders extends StatelessWidget {
  const PaidReminders({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Paid Reminder",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF102C40),
        leading: IconButton(
            onPressed: (){
              Navigator.pushNamedAndRemoveUntil(context, '/reminder', (route) => false);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )
        ),
      ),
    );
  }
}
