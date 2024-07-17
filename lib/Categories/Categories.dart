import 'package:flutter/material.dart';

class Categories {
  final String title;
  final double value;
  final double? budget;
  final Color color;

  Categories({
    required this.title,
    required this.value,
    required this.budget,
    required this.color
  });
}

class FinalCategories {
  final catList = [
    Categories(title: "Transport", value: 30000, budget: 40000, color: Colors.green),
    Categories(title: "Food", value: 70000, budget: 80000, color: Colors.red),
    Categories(title: "Health", value: 60000, budget: 60000, color: Colors.blueAccent),
    Categories(title: "Shopping", value: 40000, budget: 30000, color: Colors.purple),
    Categories(title: "Other", value: 40, budget: null, color: Colors.yellow),
  ];
}