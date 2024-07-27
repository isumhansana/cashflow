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
    Categories(title: "Transport", value: 30000, budget: null, color: const Color(0xFF4169E1)),
    Categories(title: "Foods", value: 70000, budget: null, color: const Color(0xFFDC143C)),
    Categories(title: "Health", value: 60000, budget: null, color: const Color(0xFF50C878)),
    Categories(title: "Bills", value: 40000, budget: null, color: const Color(0xFF9966CC)),
    Categories(title: "Education", value: 40000, budget: null, color: const Color(0xFF40E0D0)),
    Categories(title: "Groceries", value: 40000, budget: null, color: const Color(0xFF0047AB)),
    Categories(title: "Clothes", value: 40000, budget: null, color: const Color(0xFF32CD32)),
    Categories(title: "Entertainment", value: 40000, budget: null, color: const Color(0xFFFF00FF)),
    Categories(title: "House", value: 40000, budget: null, color: const Color(0xFF008080)),
    Categories(title: "Vehicle", value: 40000, budget: null, color: const Color(0xFF4B0082)),
    Categories(title: "Other", value: 40, budget: null, color: const Color(0xFFFFD700)),
  ];
}