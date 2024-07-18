import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class NewEntryDialog extends StatefulWidget {
  const NewEntryDialog({super.key});

  @override
  State<NewEntryDialog> createState() => _NewEntryDialogState();
}

class _NewEntryDialogState extends State<NewEntryDialog> {
  String? _dropDownValue;
  DateTime? _selectedDate;

  @override
  void initState() {
    _dropDownValue = "Expense";
    _selectedDate = DateTime.now();
    super.initState();
  }

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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            height: 63,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Text(
                      DateFormat('dd/MM/yyyy').format(_selectedDate!),
                      style: const TextStyle(
                        fontSize: 15
                      ),
                    ),
                ),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: const Icon(
                    CupertinoIcons.calendar,
                    color: Colors.black54,
                    size: 28,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime.now(),
        initialDate: DateTime.now()
    );

    if(picked!=null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}
