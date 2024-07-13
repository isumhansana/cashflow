import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
    try{
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return cred.user;
    } catch(e) {
      log('SignUp Error $e');
    }
    return null;
  }

  Future<User?> loginWithEmailAndPassword(String email, String password) async {
    try{
      final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return cred.user;
    } catch(e) {
      log("Login Error $e");
    }
    return null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}