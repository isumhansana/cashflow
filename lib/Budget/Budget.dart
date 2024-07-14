import 'package:flutter/material.dart';

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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (index){
          setState(() {
            myIndex = index;
          });
          if(myIndex == 0){
            Navigator.pushReplacementNamed(context, '/dashboard');
          } else if(myIndex == 2){
            Navigator.pushReplacementNamed(context, '/reminder');
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
