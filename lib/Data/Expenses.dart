class Expenses {
  final double amount;
  final String description;
  final String category;
  final DateTime date;

  Expenses({
    required this.amount,
    required this.description,
    required this.category,
    required this.date
  });
}

class ExpenseList {
  final exList = <Expenses>[];

  Future addExpense(double amount, String description, String category, DateTime date) async {
    exList.add(Expenses(amount: amount, description: description, category: category, date: date));
  }

}