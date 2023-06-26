import 'package:ProFlow/figma/newhomepage.dart';
import 'package:ProFlow/figma/login-screen.dart';
import 'package:ProFlow/navigation/teacher/homepage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'navigation/student/mentor finding platform/proposal_page.dart';
import 'navigation/student/mentor finding platform/find_mentor.dart';
import 'navigation/student/forum/forum.dart';
import 'navigation/student/my project/modules/home/view.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'guest_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ProFlow/navigation/student/homepage.dart';

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
            return StudentPage();
          } else if (snapshot.data == 'teacher') {
            return TeacherPage();
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
