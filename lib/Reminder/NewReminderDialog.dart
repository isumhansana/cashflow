import 'package:cashflow/Authentication/InputValidation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewReminderDialog extends StatefulWidget {
  const NewReminderDialog({super.key});

  @override
  State<NewReminderDialog> createState() => _NewReminderDialogState();
}

class _NewReminderDialogState extends State<NewReminderDialog> {
  final _user = FirebaseAuth.instance.currentUser;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  String? _dropDownValue;

  String? _amountError;

  @override
  void initState() {
    _dropDownValue = "Monthly";
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
        "New Reminder",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
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
                  errorText: _amountError
              ),
              keyboardType: TextInputType.number,
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
                    DropdownMenuItem(value: "Monthly", child: Text("Monthly"),),
                    DropdownMenuItem(value: "Yearly", child: Text("Yearly"),)
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
    if (_amountController.text != "" && _titleController.text != "" && double.tryParse(_amountController.text) != null) {
      await FirebaseFirestore.instance
          .collection('entries')
          .doc(_user!.uid)
          .collection('Reminder')
          .add({
        'title': _titleController.text,
        'amount': _amountController.text,
        'repeat': _dropDownValue,
        'paid': false,
        'date': DateTime.now()
      });
      Navigator.pop(context);
      _amountController.clear();
      _titleController.clear();
    } else if(_amountController.text != "" && _titleController.text != "" && double.tryParse(_amountController.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Amount Should be a Number"))
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Fill All the data fields"))
      );
    }
  }

}
