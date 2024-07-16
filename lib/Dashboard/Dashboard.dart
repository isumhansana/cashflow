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
  int month = DateTime.now().month;
  int year = DateTime.now().year;
  var monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

  @override
  Widget build(BuildContext context) {
    final catList = [
      Categories(title: "Transport", value: 10, color: Colors.green),
      Categories(title: "Food", value: 30, color: Colors.red),
      Categories(title: "Health", value: 20, color: Colors.blueAccent),
      Categories(title: "Shopping", value: 40, color: Colors.purple),
      Categories(title: "Other", value: 40, color: Colors.yellow),
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
            height: (MediaQuery.of(context).size.height)/2.42,
            width: (MediaQuery.of(context).size.width),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            if(month == 1){
                              month = 12;
                              year = year - 1;
                            } else {
                              month = month -1;
                            }
                          });
                        },
                        child: const Icon(
                          Icons.chevron_left_rounded
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        year==DateTime.now().year
                            ? monthNames[month-1]
                            : "${monthNames[month-1]} $year",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            if (month == DateTime.now().month && year == DateTime.now().year){
                              (){};
                            } else if(month==12){
                              month = 1;
                              year = year + 1;
                            } else {
                              month = month + 1;
                            }
                          });
                        },
                        child: const Icon(
                            Icons.chevron_right_rounded
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  AspectRatio(
                    aspectRatio: 1.4,
                    child: Stack(
                      children: [
                        PieChart(
                        PieChartData(
                          sections: catList.asMap().entries.map((mapEntry) {
                            final index = mapEntry.key;
                            final data = mapEntry.value;
                            return PieChartSectionData(
                                value: data.value,
                                color: data.color,
                                radius: pieTouchedIndex == index? 40 : 34,
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
                        const Column(
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
                        )
                      ]
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: catList.asMap().entries.map((mapEntry){
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: mapEntry.value.color,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            mapEntry.value.title
                          )
                        ],
                      );
                    }).toList(),
                  )
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
  final String title;
  final double value;
  final Color color;

  Categories({
    required this.title,
    required this.value,
    required this.color
});
}
