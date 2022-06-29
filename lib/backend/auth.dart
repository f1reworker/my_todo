import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future register(String login, String password) async {
  try {
    final result = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: login, password: password);
    await FirebaseFirestore.instance
        .collection('todos')
        .doc(result.user!.uid)
        .set({'data': []});
    await FirebaseFirestore.instance
        .collection('notes')
        .doc(result.user!.uid)
        .set({'data': []});
    return result.user!.uid;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      return 1;
    } else if (e.code == 'invalid-email') {
      return 2;
    } else if (e.code == 'email-already-in-use') {
      return 0;
    }
  } catch (e) {
    return -1;
  }
}

Future login(String login, String password) async {
  try {
    final result = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: login, password: password);
    return result.user!.uid;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found' || e.code == 'wrong-password') {
      return 0;
    } else {
      return -1;
    }
  }
}

bool _data1 = true;

class AuthProvider with ChangeNotifier {
  bool get isLogggedIn => _data1;
  void isLogIn(bool isLoggedIn) {
    _data1 = isLoggedIn;
    notifyListeners();
  }
}
