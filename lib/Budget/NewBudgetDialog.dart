import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Categories/Categories.dart';

class NewBudgetDialog extends StatefulWidget {
  const NewBudgetDialog({super.key});

  @override
  State<NewBudgetDialog> createState() => _NewBudgetDialogState();
}

class _NewBudgetDialogState extends State<NewBudgetDialog> {
  final TextEditingController _amountController = TextEditingController();
  String? _dropDownValue;
  final catList = FinalCategories().catList;
  final _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "New Budget",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton(
                  items: catList.asMap().entries.map((mapEntry){
                    return DropdownMenuItem(value: mapEntry.value.title, child: Text(mapEntry.value.title));
                  }).toList(),
                  hint: const Text("Category"),
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 16
                  ),
                  value: _dropDownValue,
                  itemHeight: 63,
                  underline: const SizedBox(),
                  isExpanded: true,
                  onChanged: dropDownCallBack
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: "Amount",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
              ),
            ),
            const SizedBox(height: 16),
            MaterialButton(
              onPressed: _add,
              color: const Color(0xff235AE8),
              minWidth: 120,
              height: 43,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: const BorderSide(color: Colors.black)
              ),
              child: const Text(
                'Add',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.normal
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void dropDownCallBack(String? selectedValue) {
    if (selectedValue!=null){
      setState(() {
        _dropDownValue = selectedValue;
      });
    }
  }

  _add() async {
    if (_dropDownValue != null && _amountController.text != "") {
      await FirebaseFirestore.instance
          .collection('entries')
          .doc(_user!.uid)
          .collection("Budget")
          .add({
        'amount': _amountController.text,
        'category': _dropDownValue
      });
      Navigator.pop(context);
      _amountController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Fill All the data fields"))
      );
    }

  }
}
