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
  List<Expenses> exList = List.empty(growable: true);

  void addExpense(double amount, String description, String category, DateTime date) {
    exList.add(Expenses(amount: amount, description: description, category: category, date: date));
  }

}