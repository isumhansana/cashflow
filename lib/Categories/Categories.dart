import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Categories {
  final String title;
  double value;
  double? budget;
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
    Categories(title: "Transport", value: 0, budget: null, color: const Color(0xFF0047AB)),
    Categories(title: "Foods", value: 0, budget: null, color: const Color(0xFFDC143C)),
    Categories(title: "Health", value: 0, budget: null, color: const Color(0xFF50C878)),
    Categories(title: "Bills", value: 0, budget: null, color: const Color(0xFF9966CC)),
    Categories(title: "Education", value: 0, budget: null, color: const Color(0xFF40E0D0)),
    Categories(title: "Groceries", value: 0, budget: null, color: const Color(0xFF4169E1)),
    Categories(title: "Clothes", value: 0, budget: null, color: const Color(0xFF32CD32)),
    Categories(title: "Entertainment", value: 0, budget: null, color: const Color(0xFFFF00FF)),
    Categories(title: "House", value: 0, budget: null, color: const Color(0xFF008080)),
    Categories(title: "Vehicle", value: 0, budget: null, color: const Color(0xFF4B0082)),
    Categories(title: "Other", value: 0, budget: null, color: const Color(0xFFFFD700)),
  ];
  final _user = FirebaseAuth.instance.currentUser;

  Future<List<Categories>> getData() async {
    QuerySnapshot<Map<String, dynamic>> budgetSnapshot = await FirebaseFirestore.instance.collection("entries").doc(_user!.uid).collection("Budget").get();
    budgetSnapshot.docs.map((entry) {
      catList.map((mapEntry) {
        if(mapEntry.title == entry['category']) {
          mapEntry.budget = double.parse(entry['amount']);
        }
      }).toList();
    }).toList();

    QuerySnapshot<Map<String, dynamic>> expenseSnapshot = await FirebaseFirestore.instance.collection("entries").doc(_user.uid).collection("Expense").get();
    expenseSnapshot.docs.map((entry) {
      catList.map((mapEntry) {
        if(mapEntry.title == entry['category']) {
          mapEntry.value = mapEntry.value + double.parse(entry['amount']);
        }
      }).toList();
    }).toList();
    return catList;
  }
}