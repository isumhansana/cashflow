import 'package:cashflow/Data/Expenses.dart';

class ExpenseHandler {
  final exList = ExpenseList().exList;

  void addExpense(double amount, String description, String category, DateTime date) {
    exList.add(Expenses(amount: amount, description: description, category: category, date: date));
  }
}