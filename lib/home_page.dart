import 'package:ProFlow/navigation/teacher/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ProFlow/navigation/student/homepage.dart';
import 'package:ProFlow/guest_page.dart';

import 'navigation/student/create group/proposal_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: GetIdentity(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data == 'student') {
            return FutureBuilder(
              future: GetDocUid(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == 'placeholder') {
                    return ProposalPage();
                  } else {
                    return StudentPage();
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            );
          } else if (snapshot.data == 'teacher') {
            if (snapshot.hasData) {
              if (snapshot.data == 'placeholder') {
                return ProposalPage();
              } else {
                return StudentPage();
              }
            } else {
              return CircularProgressIndicator();
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
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
