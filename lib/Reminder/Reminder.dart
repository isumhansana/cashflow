import 'package:flutter/material.dart';

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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (index){
          setState(() {
            myIndex = index;
          });
          if(myIndex == 0){
            Navigator.pushReplacementNamed(context, '/dashboard');
          } else if(myIndex == 1){
            Navigator.pushReplacementNamed(context, '/budget');
          } else if(myIndex == 3){
            Navigator.pushReplacementNamed(context, '/profile');
          }
        },
        currentIndex: myIndex,
        backgroundColor: const Color(0xFF102C40),
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color(0xFF636363),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart_outlined),
            label: "Budget",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active_outlined),
            label: "Reminder",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          )
        ],
      ),
    );
  }
}
