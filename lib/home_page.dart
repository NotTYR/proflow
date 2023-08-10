import 'package:ProFlow/navigation/teacher/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ProFlow/navigation/student/homepage.dart';
import 'package:ProFlow/guest_page.dart';

import 'navigation/student/create group/create_group.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('groups').snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return FutureBuilder(
            future: GetDocUid(),
            builder: ((context, snapshot) {
              print(snapshot.data);
              if (snapshot.hasData) {
                if (snapshot.data == 'placeholder') {
                  return ProposalPage();
                } else {
                  print('in a group');
                  return StudentPage();
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
      },
    );
  }
}

Future<String> GetIdentity() async {
  final prefs = await SharedPreferences.getInstance();
  final identity = await prefs.getString('identity');
  if (identity != null) {
    return identity;
  } else {
    return '';
  }
}
