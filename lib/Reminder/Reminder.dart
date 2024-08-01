import 'package:cashflow/Reminder/NewReminderDialog.dart';
import 'package:flutter/material.dart';

import '../NavBar.dart';

class Reminder extends StatefulWidget {
  const Reminder({super.key});

  @override
  State<Reminder> createState() => _ReminderState();
}

class _ReminderState extends State<Reminder> {
  int myIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Reminder",
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
    );
  }

  _floatingButton() async {
    await showDialog(
        context: context,
        builder: (_) => const NewReminderDialog()
    );
    setState(() {});
  }

}
