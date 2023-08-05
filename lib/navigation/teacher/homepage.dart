import 'package:ProFlow/home_page.dart';
import 'package:ProFlow/navigation/student/chat/chat_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ProFlow/navigation/student/create%20group/create_group.dart';
import 'package:ProFlow/navigation/student/create%20group/find_mentor.dart';
import 'package:ProFlow/navigation/student/forum/forum.dart';
import 'package:ProFlow/navigation/student/my%20project/modules/home/view.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ProFlow/guest_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ProFlow/navigation/student/homepage.dart';

import '../../utils.dart';

class TeacherPage extends StatefulWidget {
  const TeacherPage({super.key});

  @override
  State<TeacherPage> createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  @override
  Widget build(BuildContext context) {
    double baseWidth = 430;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: SvgPicture.asset('assets/proflow.svg'),
              height: MediaQuery.of(context).size.height * 0.15,
              width: MediaQuery.of(context).size.height * 0.15,
              margin: const EdgeInsets.only(bottom: 40.0),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width * 0.8,
              margin: const EdgeInsets.only(
                top: 0.0,
                bottom: 50.0,
              ),
              child: FittedBox(
                child: Text(
                  'ProFlow',
                  style: TextStyle(
                    color: Color(0xFF3874CB),
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width * 0.8,
              margin: const EdgeInsets.only(
                top: 0.0,
                bottom: 10.0,
              ),
              child: Container(
                margin:
                    EdgeInsets.fromLTRB(0 * fem, 0 * fem, 1 * fem, 56 * fem),
                child: FittedBox(
                  child: Text('Teacher',
                      style: SafeGoogleFont(
                        'Inter',
                        fontSize: 24 * ffem,
                        fontWeight: FontWeight.w400,
                        height: 1.2125 * ffem / fem,
                        color: Color(0xff000000),
                      )),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 90.0,
                  child: FeatureButton(
                      buttonName: 'Mentor',
                      buttonIcon: Icons.search_rounded,
                      buttonRoute: FindMentor()),
                ),
                SizedBox(
                  height: 90.0,
                  child: FeatureButton(
                      buttonName: 'Projects',
                      buttonIcon: Icons.list_alt_rounded,
                      buttonRoute: MyProjects()),
                ),
                SizedBox(
                  height: 90.0,
                  child: FeatureButton(
                      buttonName: 'Forum',
                      buttonIcon: Icons.question_answer,
                      buttonRoute: ForumExp()),
                ),
                SizedBox(
                  height: 90.0,
                  child: FeatureButton(
                      buttonName: 'Text/Voice',
                      buttonIcon: Icons.voice_chat,
                      buttonRoute: Chat()),
                ),
              ],
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            try {
              await FirebaseAuth.instance.signOut();
              await GoogleSignIn().signOut();
              Navigator.pop(context,
                  MaterialPageRoute(builder: ((context) => GuestPage())));
            } catch (e) {
              print(e.toString());
            }
          },
          child: Icon(Icons.logout_outlined),
        ));
  }
}

class FeatureButton extends StatelessWidget {
  FeatureButton(
      {super.key,
      required this.buttonName,
      required this.buttonIcon,
      required this.buttonRoute});
  final String buttonName;
  final IconData buttonIcon;
  final Widget buttonRoute;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RawMaterialButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => buttonRoute));
          },
          fillColor: Color(0xFF3874CB),
          child: Icon(
            buttonIcon,
            color: Colors.white,
          ),
          padding: EdgeInsets.all(15.0),
          shape: CircleBorder(),
        ),
        SizedBox(height: 10),
        Text(
          buttonName,
          style: TextStyle(fontWeight: FontWeight.w600),
        )
      ],
    );
  }
}
