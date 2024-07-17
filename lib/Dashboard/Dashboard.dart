import 'package:cashflow/Categories/Categories.dart';
import 'package:cashflow/NavBar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'PieChartMiddle.dart';

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

    final catList = FinalCategories().catList;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Dashboard",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF102C40),
      ),
      bottomNavigationBar: NavBar(myIndex),
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
            height: (MediaQuery.of(context).size.height)/2.6,
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
                        const PieChartMiddle()
                      ]
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
              height: 348,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Categories",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25
                      ),
                    ),
                    const SizedBox(height: 20),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: catList.asMap().entries.map((mapEntry){
                            final budget = mapEntry.value.budget;
                            final value = mapEntry.value.value;
                            return Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black
                                      ),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)
                                      )
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              mapEntry.value.title,
                                              style: TextStyle(
                                                  color: mapEntry.value.color,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20
                                              ),
                                            ),
                                            Text(
                                              "Rs. $value",
                                              style: const TextStyle(
                                                fontSize: 20
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              budget==null
                                                  ? const Text("No budget")
                                                  : Text(
                                                "Remaining Budget: Rs. ${budget-value}",
                                                style: TextStyle(
                                                    color: Color(budget>value? 0xFF03AB00: (budget<value? 0xFFF60707: 0xFF000000)),
                                                    fontSize: 15
                                                ),
                                              )
                                            ]
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            );
                          }).toList(),
                        ),
                      ]
                    ),
              ),
            ),
          )
              ],
            ),
          );
  }
}
