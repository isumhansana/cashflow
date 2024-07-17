import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  final int myIndex;
  const NavBar(this.myIndex, {super.key});


  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int myIndex = 0;

  @override
  void initState(){
    super.initState();
    myIndex = widget.myIndex;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: (index){
        setState(() {
          myIndex = index;
        });
        if(myIndex == 0){
          Navigator.pushReplacementNamed(context, '/dashboard');
        } else if(myIndex == 1){
          Navigator.pushReplacementNamed(context, '/budget');
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
    );
  }
}
