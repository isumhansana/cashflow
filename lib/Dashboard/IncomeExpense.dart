import 'package:cashflow/Data/Expenses.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Categories/Categories.dart';
import '../Data/Incomes.dart';

class IncomeExpense extends StatefulWidget {
  final int year;
  final int month;
  final double income;
  const IncomeExpense(this.year, this.month, this.income, {super.key});

  @override
  State<IncomeExpense> createState() => _IncomeExpenseState();
}

class _IncomeExpenseState extends State<IncomeExpense> {
  int year = 0;
  int month = 0;
  double income = 0;
  var exList = <Expenses>[];

  @override
  void initState() {
    super.initState();
    year = widget.year;
    month = widget.month;
    income = widget.income;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Incomes & Expenses",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFF102C40),
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: ExpenseList().getExpenses(),
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.waiting
                  ? const Center(child: CupertinoActivityIndicator())
                  : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
                    child: Column(
                        children: [
                          ExpansionTile(
                            title: const Text(
                              "Incomes",
                              style: TextStyle(fontSize: 20),
                            ),
                            shape: const Border(),
                            trailing: Text(
                              "Rs. ${income.toInt()}",
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF03AB00),
                                  fontWeight: FontWeight.normal
                              ),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: FutureBuilder(
                                    future: IncomeList().getIncomes(),
                                    builder: (context, snapshot) {
                                      return snapshot.connectionState == ConnectionState.waiting
                                          ? const SizedBox()
                                          : Column(
                                        children: snapshot.data!.asMap().entries.map((mapEntry) {
                                          return Column(
                                            children: [
                                              int.parse(DateFormat("yyyy").format(mapEntry.value.date.toDate())) == year && int.parse(DateFormat("MM").format(mapEntry.value.date.toDate())) == month
                                                  ? Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                          Text(
                                                            "Rs. ${mapEntry.value.amount.toInt()}   ${mapEntry.value.description}",
                                                            style: const TextStyle(fontSize: 16),
                                                          ),
                                                          Text(
                                                            DateFormat("dd MMM").format(
                                                                mapEntry.value.date.toDate()
                                                            ),
                                                            style: const TextStyle(fontSize: 16),
                                                          ),
                                                        ]
                                                    ) : const SizedBox()
                                                  ],
                                          );
                                        }).toList(),
                                      );
                                    }),
                              ),
                            ],
                          ),
                          FutureBuilder(
                              future: ExpenseList().getExpenses(),
                              builder: (context, snapshot) {
                                return snapshot.connectionState == ConnectionState.waiting
                                    ? const SizedBox()
                                    : Column(
                                        children: snapshot.data!.asMap().entries.map((mapEntry) {
                                          return Column(
                                            children: [
                                              int.parse(DateFormat("yyyy").format(mapEntry.value.date.toDate())) == year && int.parse(DateFormat("MM").format(mapEntry.value.date.toDate())) == month
                                              ? Row(children: [
                                                 Text(mapEntry.value.category),
                                                 Text(mapEntry.value.description),
                                                 Text(
                                                     DateFormat("dd MMM").format(
                                                         mapEntry.value.date.toDate()
                                                     )
                                                 ),
                                                 Text(mapEntry.value.amount.toString())
                                               ]
                                              ) : const SizedBox()
                                            ],
                                          );
                                        }).toList(),
                                      );
                              }),
                        ],
                                ),
                  );
            }
          ),
        ));
  }
}
