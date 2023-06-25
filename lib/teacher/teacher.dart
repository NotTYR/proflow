import 'package:ProFlow/figma/newhomepage.dart';
import 'package:ProFlow/figma/login-screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ProFlow/navigation/proposal_page.dart';
import 'package:ProFlow/navigation/find_mentor.dart';
import 'package:ProFlow/navigation/forum.dart';
import 'package:ProFlow/navigation/my project/modules/home/view.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ProFlow/guest_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ProFlow/student/student.dart';

class TeacherPage extends StatefulWidget {
  const TeacherPage({super.key});

  @override
  State<TeacherPage> createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  @override
  Widget build(BuildContext context) {
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
                      buttonIcon: Icons.chat_outlined,
                      buttonRoute: ForumExp()),
                ),
                SizedBox(
                  height: 90.0,
                  child: FeatureButton(
                      buttonName: 'Propose',
                      buttonIcon: Icons.handshake_outlined,
                      buttonRoute: ProposalPage()),
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
              Navigator.pop(
                  context, MaterialPageRoute(builder: ((context) => Scene())));
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
