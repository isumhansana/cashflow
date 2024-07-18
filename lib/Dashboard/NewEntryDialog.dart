import 'package:flutter/material.dart';

class NewEntryDialog extends StatelessWidget {
  const NewEntryDialog({super.key});

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
        ],
      ),
    );
  }
}
