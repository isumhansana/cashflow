import 'package:cashflow/Data/Expenses.dart';

class ExpenseHandler {
  final exList = ExpenseList().exList;

  Future addExpense(double amount, String description, String category, DateTime date) async {
    exList.add(Expenses(amount: amount, description: description, category: category, date: date));
  }
}