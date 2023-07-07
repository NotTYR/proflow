import 'package:ProFlow/extensions.dart';
import 'package:ProFlow/navigation/student/text%20and%20voice/chat_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ProFlow/navigation/student/mentor%20finding%20platform/find_mentor.dart';
import 'package:ProFlow/navigation/student/forum/forum.dart';
import 'package:ProFlow/navigation/student/my%20project/modules/home/view.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ProFlow/guest_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: SvgPicture.asset('assets/proflow.svg'),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              margin: EdgeInsets.only(
                top: 4.0.hp,
                bottom: 3.0.hp,
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
                width: MediaQuery.of(context).size.width * 0.6,
                margin: EdgeInsets.only(
                  bottom: 6.0.hp,
                ),
                child: const FittedBox(
                    child: Text(
                  'Experience Redefined',
                  style: TextStyle(
                    color: Color.fromARGB(255, 187, 187, 187),
                    fontStyle: FontStyle.italic,
                  ),
                ))),
            Padding(
              padding: EdgeInsets.only(bottom: 3.0.hp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 9.0.hp,
                    child: FeatureButton(
                        buttonName: 'Mentor',
                        buttonIcon: Icons.search_rounded,
                        buttonRoute: FindMentor()),
                  ),
                  SizedBox(
                    height: 9.0.hp,
                    child: FeatureButton(
                        buttonName: 'Projects',
                        buttonIcon: Icons.list_alt_rounded,
                        buttonRoute: MyProjects()),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 9.0.hp,
                  child: FeatureButton(
                      buttonName: 'Forum',
                      buttonIcon: Icons.question_answer,
                      buttonRoute: ForumExp()),
                ),
                SizedBox(
                  height: 9.0.hp,
                  child: FeatureButton(
                      buttonName: 'Text/Voice',
                      buttonIcon: Icons.voice_chat,
                      buttonRoute: ChatPage()),
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
