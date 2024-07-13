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

  Future<String> passwordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return "Check Your Inbox for Password Reset Email";
    } on FirebaseAuthException catch(e) {
      log("Error: $e");
      return "Password Reset Failed! Try Again";
    }
  }
}