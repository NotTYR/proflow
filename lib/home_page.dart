import 'package:ProFlow/navigation/teacher/homepage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ProFlow/navigation/student/homepage.dart';
import 'package:ProFlow/guest_page.dart';

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
