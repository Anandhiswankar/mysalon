import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<User?> getCurrentUser() async {
  return FirebaseAuth.instance.currentUser;
}
