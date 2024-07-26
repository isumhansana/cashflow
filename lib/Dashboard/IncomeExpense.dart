import 'package:cashflow/Data/Expenses.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IncomeExpense extends StatefulWidget {
  final int year;
  final int month;
  const IncomeExpense(this.year, this.month, {super.key});

  @override
  State<IncomeExpense> createState() => _IncomeExpenseState();
}

class _IncomeExpenseState extends State<IncomeExpense> {
  int year = 0;
  int month = 0;
  var exList = <Expenses>[];

  @override
  void initState() {
    super.initState();
    year = widget.year;
    month = widget.month;
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
        body: FutureBuilder(
            future: ExpenseList().getExpenses(),
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.waiting
                  ? const Center(child: CupertinoActivityIndicator())
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
            }));
  }
}
