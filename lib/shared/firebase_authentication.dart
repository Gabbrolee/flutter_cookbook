import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:flutter/cupertino.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class FirebaseAuthentication{

  Future<String?> createUser( String email, String password) async{
    try{
       User? credential = (await _firebaseAuth
           .createUserWithEmailAndPassword(email: email, password: password)).user;
    } on FirebaseAuthException{
      return null;
    }
  }

  Future<String?> login( String email,  String password) async {
    try{
      User? credential = (await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password)).user;
    }on FirebaseAuthException {
      return null;
    }
  }

  Future<bool> logout() async{
    try{
      _firebaseAuth.signOut();
      return true;
    } on FirebaseAuthException{
      return false;
    }

  }

}