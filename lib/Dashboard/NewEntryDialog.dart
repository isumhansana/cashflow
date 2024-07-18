import 'package:flutter/material.dart';

class NewEntryDialog extends StatefulWidget {
  const NewEntryDialog({super.key});

  @override
  State<NewEntryDialog> createState() => _NewEntryDialogState();
}

class _NewEntryDialogState extends State<NewEntryDialog> {
  var _dropDownValue = "Income";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("New Entry"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: "Amount",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: InputDecoration(
              labelText: "Description",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButton(
                items: const [
                  DropdownMenuItem(value: "Income", child: Text("Income"),),
                  DropdownMenuItem(value: "Expense", child: Text("Expense"),)
                ],
                value: _dropDownValue,
                itemHeight: 63,
                isExpanded: true,
                onChanged: dropDownCallBack
            ),
          )
        ],
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
