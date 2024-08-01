import 'package:cashflow/Authentication/AuthService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'InputValidation.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _auth = AuthService();
  final TextEditingController _emailController = TextEditingController();
  String? _emailError;

  @override
  void initState() {
    _emailController.addListener(_validateEmail);
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    setState(() {
      _emailError = EmailValidator.validate(_emailController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                errorText: _emailError,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 25),
            MaterialButton(
              onPressed: _passwordReset,
              color: const Color(0xff235AE8),
              minWidth: 150,
              height: 50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: const BorderSide(color: Colors.black)
              ),
              child: const Text(
                'Send Password Reset Email',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.normal
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }

  _passwordReset() async {
    var msg = "You don't have an Account";
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection("users").get();
    for(var entry in snapshot.docs) {
      if(entry['email'] == _emailController.text.trim()) {
        msg = await _auth.passwordReset(_emailController.text.trim());
        break;
      }
    }
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg))
    );
  }
}
