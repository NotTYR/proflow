import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

void signOut(context, page) async {
  await FirebaseAuth.instance.signOut();
  await GoogleSignIn().signOut();
  Navigator.push(context, MaterialPageRoute(builder: ((context) => page)));
}
