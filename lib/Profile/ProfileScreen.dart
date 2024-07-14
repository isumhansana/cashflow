import 'package:cashflow/Authentication/AuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = AuthService();
  final _user = FirebaseAuth.instance.currentUser;
  final TextEditingController _userEmail = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userEmail.text = _user!.email.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF102C40),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "User Details",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "User Name: Example Name",
              style: TextStyle(
                  fontSize: 22
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Email: ${_userEmail.text}",
              style: const TextStyle(
                  fontSize: 22
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  onPressed: _resetPassword,
                  color: const Color(0xff235AE8),
                  minWidth: 250,
                  height: 50,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: const BorderSide(color: Colors.black)
                  ),
                  child: const Text(
                    'Reset Password',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.normal
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  onPressed: _logout,
                  color: const Color(0xFFB43131),
                  minWidth: 250,
                  height: 50,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: const BorderSide(color: Colors.black)
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.normal
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  _logout() async {
    _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  _resetPassword() async {
    final msg = await _auth.passwordReset(_userEmail.text);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg))
    );
  }
}
