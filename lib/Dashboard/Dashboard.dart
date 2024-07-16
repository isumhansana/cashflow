import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int pieTouchedIndex = -1;
  int myIndex = 0;

  @override
  Widget build(BuildContext context) {
    final catList = [
      Categories(value: 10, color: Colors.green),
      Categories(value: 30, color: Colors.red),
      Categories(value: 20, color: Colors.blueAccent),
      Categories(value: 40, color: Colors.purple),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Dashboard",
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
          if(myIndex == 1){
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        backgroundColor: const Color(0xFF235AE8),
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFFD9D9D9),
            height: (MediaQuery.of(context).size.height)/2.5,
            width: (MediaQuery.of(context).size.width),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                      "Month",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 10),
                  AspectRatio(
                    aspectRatio: 1.4,
                    child: PieChart(
                      PieChartData(
                        sections: catList.asMap().entries.map((mapEntry) {
                          final index = mapEntry.key;
                          final data = mapEntry.value;
                          return PieChartSectionData(
                              value: data.value,
                              color: data.color,
                              radius: pieTouchedIndex == index? 50 : 40,
                              showTitle: pieTouchedIndex == index
                          );
                        }).toList(),
                        pieTouchData: PieTouchData(
                          touchCallback: (
                            FlTouchEvent e,
                            PieTouchResponse? r
                          ) {
                            setState(() {
                              if (!e.isInterestedForInteractions ||
                                  r == null ||
                                  r.touchedSection == null) {
                                    pieTouchedIndex = -1;
                                    return;
                                  }
                              pieTouchedIndex = r.touchedSection!.touchedSectionIndex;
                            });
                          }
                        )
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Categories {
  final double value;
  final Color color;

  Categories({
    required this.value,
    required this.color
});
}
