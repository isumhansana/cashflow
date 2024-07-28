import 'package:cashflow/Authentication/InputValidation.dart';
import 'package:cashflow/Categories/Categories.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewEntryDialog extends StatefulWidget {
  const NewEntryDialog({super.key});

  @override
  State<NewEntryDialog> createState() => _NewEntryDialogState();
}

class _NewEntryDialogState extends State<NewEntryDialog> {
  final _user = FirebaseAuth.instance.currentUser;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _dropDownValue;
  DateTime? _selectedDate;
  String? _categoryDropDownValue;
  final catList = FinalCategories().catList;

  String? _amountError;

  @override
  void initState() {
    _dropDownValue = "Expense";
    _selectedDate = DateTime.now();
    _amountController.addListener(_validateAmount);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _amountController.dispose();
  }

  void _validateAmount() {
    setState(() {
      _amountError = NumberValidator.validate(_amountController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "New Entry",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: "Amount",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                errorText: _amountError
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _descriptionController,
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
            _dropDownValue=="Expense" ? Container(
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
                  value: _categoryDropDownValue,
                  itemHeight: 63,
                  underline: const SizedBox(),
                  isExpanded: true,
                  onChanged: categoryDropDownCallBack
              ),
            ) : const SizedBox(),
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

  void categoryDropDownCallBack(String? selectedValue) {
    if (selectedValue!=null){
      setState(() {
        _categoryDropDownValue = selectedValue;
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

  _add() async {
    if ((_categoryDropDownValue != null || _dropDownValue == 'Income') && _amountController.text != "" && _descriptionController.text != "") {
      await FirebaseFirestore.instance
          .collection('entries')
          .doc(_user!.uid)
          .collection(_dropDownValue!)
          .add({
        'amount': _amountController.text,
        'description': _descriptionController.text,
        'date': _selectedDate,
        'category': _dropDownValue=="Expense"? _categoryDropDownValue: _dropDownValue
      });
      Navigator.pop(context);
      _amountController.clear();
      _descriptionController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fill All the data fields"))
      );
    }

  }
}
