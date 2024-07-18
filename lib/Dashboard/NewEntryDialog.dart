import 'package:flutter/material.dart';

class NewEntryDialog extends StatelessWidget {
  const NewEntryDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      title: Text("New Entry"),
      content: Text("New Entry"),
    );
  }
}
