import 'package:cashflow/Authentication/AuthService.dart';
import 'package:cashflow/Authentication/InputValidation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _auth = AuthService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _usernameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_validateUsername);
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
    _confirmPasswordController.addListener(_confirmPassword);
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  void _validateUsername() {
    setState(() {
      _usernameError = UsernameValidator.validate(_usernameController.text);
    });
  }

  void _validateEmail() {
    setState(() {
      _emailError = EmailValidator.validate(_emailController.text);
    });
  }

  void _validatePassword() {
    setState(() {
      _passwordError = PasswordValidator.validate(_passwordController.text);
    });
  }

  void _confirmPassword() {
    setState(() {
      _confirmPasswordError = PasswordConfirm.validate(_passwordController.text, _confirmPasswordController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SignUp', style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: const Color(0xff102C40),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 15),
                Image.asset(
                  "assets/imgs/cashflow_logo.png",
                  height: 180,
                  width: 180,
                ),
                const SizedBox(height: 10,),
                const Text(
                  "CashFlow",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                      labelText: "User Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                    errorText: _usernameError,
                  ),
                ),
                const SizedBox(height: 10),
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
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                    errorText: _passwordError,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: "Re-Enter Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                    errorText: _confirmPasswordError,
                  ),
                ),
                const SizedBox(height: 25),
                MaterialButton(
                  onPressed: _signup,
                  color: const Color(0xff235AE8),
                  minWidth: 150,
                  height: 50,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: const BorderSide(color: Colors.black)
                  ),
                  child: const Text(
                    'SignUp',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.normal
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                const Text(
                  "Already have an account?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                  child: const Text(
                    "Login Here",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
  _signup() async {
    final user = await _auth.createUserWithEmailAndPassword(_emailController.text, _passwordController.text);
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': _usernameController.text.trim(),
        'email': user.email
      });
      Navigator.pushReplacementNamed(context, '/login');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account Created! Please Login to Continue"))
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("SignUp Failed! Please Check Your Connection"))
      );
    }
  }
}
