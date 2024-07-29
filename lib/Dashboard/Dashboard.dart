import 'package:cashflow/Categories/Categories.dart';
import 'package:cashflow/Dashboard/NewEntryDialog.dart';
import 'package:cashflow/NavBar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:number_editing_controller/number_editing_controller.dart';

import 'PieChartMiddle.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int pieTouchedIndex = -1;
  NumberEditingTextController month = NumberEditingTextController.integer();
  NumberEditingTextController year = NumberEditingTextController.integer();
  int myIndex = 0;
  var monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

  @override
  void initState() {
    super.initState();
    month.number = DateTime.now().month;
    year.number = DateTime.now().year;
  }

  @override
  void dispose() {
    super.dispose();
    month.dispose();
    year.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        onPressed: _floatingButton,
        backgroundColor: const Color(0xFF235AE8),
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: FutureBuilder(
        future: FinalCategories().getData(year.number!.toInt(), month.number!.toInt()),
        builder: (context, dataSnapshot) {
          return dataSnapshot.connectionState == ConnectionState.waiting
              ? const Center(child: CupertinoActivityIndicator())
              : Column(
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
                              onTap: _monthDecrement,
                              child: const Icon(
                                Icons.chevron_left_rounded
                              ),
                            ),
                            const SizedBox(width: 20),
                            Text(
                              year.number!.toDouble()==DateTime.now().year.toDouble()
                                  ? monthNames[month.number!.toInt()-1]
                                  : "${monthNames[month.number!.toInt()-1]} ${year.number}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            const SizedBox(width: 20),
                            GestureDetector(
                              onTap: _monthIncrement,
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
                                sections: dataSnapshot.data!.asMap().entries.map((mapEntry) {
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
                              PieChartMiddle(year.number!.toInt(), month.number!.toInt())
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
                                children: dataSnapshot.data!.asMap().entries.map((mapEntry){
                                  final budget = mapEntry.value.budget;
                                  final value = mapEntry.value.value;
                                  return Column(
                                    children: [
                                      mapEntry.value.value==0
                                          ? const SizedBox.shrink()
                                          : Column(
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
                                          ),
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
                  );
        }
      ),
          );
  }

  _monthDecrement() {
    setState(() {
      if(month.number == 1){
        month.number = 12;
        year.number = year.number! - 1;
      } else {
        month.number = month.number! - 1;
      }
    });
  }

  _monthIncrement() {
    setState(() {
      if (month.number == DateTime.now().month && year.number == DateTime.now().year){
            (){};
      } else if(month.number==12){
        month.number = 1;
        year.number = year.number! + 1;
      } else {
        month.number = month.number! + 1;
      }
    });
  }

  _floatingButton() async {
    await showDialog(
        context: context,
        builder: (_) => const NewEntryDialog()
    );
    setState(() {});
  }
}
