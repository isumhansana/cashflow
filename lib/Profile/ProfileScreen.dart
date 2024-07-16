import 'package:cashflow/Authentication/AuthService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int myIndex = 3;
  final _auth = AuthService();
  final _user = FirebaseAuth.instance.currentUser;
  final TextEditingController _userEmail = TextEditingController();
  final TextEditingController _userName = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userEmail.text = _user!.email.toString();
  }

  @override
  void dispose() {
    super.dispose();
    _userEmail.dispose();
    _userName.dispose();
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            myIndex = index;
          });
          if (myIndex == 0) {
            Navigator.pushReplacementNamed(context, '/dashboard');
          } else if (myIndex == 1) {
            Navigator.pushReplacementNamed(context, '/budget');
          } else if (myIndex == 2) {
            Navigator.pushReplacementNamed(context, '/reminder');
          }
        },
        currentIndex: myIndex,
        backgroundColor: const Color(0xFF102C40),
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color(0xFF636363),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart_outlined),
            label: "Budget",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active_outlined),
            label: "Reminder",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          )
        ],
      ),
      body: FutureBuilder(
          future: _getName(),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? const Center(child: CupertinoActivityIndicator())
                : Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "User Details",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          "User Name",
                          style: TextStyle(fontSize: 22),
                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(15, 3, 0, 0),
                            child: Text(
                              _userName.text,
                              style: const TextStyle(fontSize: 22),
                            )
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Email",
                          style: TextStyle(fontSize: 22),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 3, 0, 0),
                          child: Text(
                            _userEmail.text,
                            style: const TextStyle(fontSize: 22),
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
                                  side: const BorderSide(color: Colors.black)),
                              child: const Text(
                                'Reset Password',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal),
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
                                  side: const BorderSide(color: Colors.black)),
                              child: const Text(
                                'Logout',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
          }),
    );
  }

  _logout() async {
    _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  _resetPassword() async {
    final msg = await _auth.passwordReset(_userEmail.text);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  _getName() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_user!.uid)
        .get()
        .then((value) {
      _userName.text = value['name'];
    });
  }
}
