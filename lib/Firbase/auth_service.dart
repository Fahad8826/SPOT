import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

// SignUP
  Future<User?> createUserwithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (e) {
      log('something went wrong');
    }
    return null;
  }

  // SignIn
  Future<User?> loginUserwithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (e) {
      log('something went wrong');
    }
    return null;
  }


  // signOut Funtion
  Future<void> signOut() async{
    try{
      await _auth.signOut();
    }catch(e){
      log("Failed to SignOut");
    }
  }

  
}
