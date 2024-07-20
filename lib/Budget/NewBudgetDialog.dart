import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Categories/Categories.dart';

class NewBudgetDialog extends StatefulWidget {
  const NewBudgetDialog({super.key});

  @override
  State<NewBudgetDialog> createState() => _NewBudgetDialogState();
}

class _NewBudgetDialogState extends State<NewBudgetDialog> {
  String? _dropDownValue;
  final catList = FinalCategories().catList;

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
              decoration: InputDecoration(
                labelText: "Amount",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
              ),
            ),
            const SizedBox(height: 16),
            MaterialButton(
              onPressed: (){},
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
}
