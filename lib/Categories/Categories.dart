import 'package:flutter/material.dart';

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

class FinalCategories {
  final catList = [
    Categories(title: "Transport", value: 10, color: Colors.green),
    Categories(title: "Food", value: 30, color: Colors.red),
    Categories(title: "Health", value: 20, color: Colors.blueAccent),
    Categories(title: "Shopping", value: 40, color: Colors.purple),
    Categories(title: "Other", value: 40, color: Colors.yellow),
  ];
}