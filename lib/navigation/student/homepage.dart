import 'package:ProFlow/extensions.dart';
import 'package:ProFlow/navigation/student/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ProFlow/guest_page.dart';
import 'package:ProFlow/navigation/student/chat/chat_page.dart';
import 'package:ProFlow/navigation/student/forum/view.dart';
import 'package:ProFlow/navigation/student/my%20project/modules/home/view.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final Object _helpHeroTag = UniqueKey();

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
                  child: FeatureButton(
                      buttonName: 'Forum',
                      buttonIcon: Icons.question_answer,
                      buttonRoute: ForumExp()),
                ),
                SizedBox(
                  child: FeatureButton(
                      buttonName: 'My Project',
                      buttonIcon: Icons.list_alt_rounded,
                      buttonRoute: MyProjects()),
                ),
                SizedBox(
                  child: FeatureButton(
                      buttonName: 'Chat',
                      buttonIcon: Icons.chat,
                      buttonRoute: Chat()),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 15.0.hp,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => OnboardingPage()));
              },
              child: Icon(Icons.help_outline_outlined),
              heroTag: _helpHeroTag,
            ),
          ),
          SizedBox(width: 0.2.hp),
          FloatingActionButton(
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();
                await GoogleSignIn().signOut();
                Get.to(() => GuestPage(), transition: Transition.noTransition);
              } catch (e) {
                print('homepaeg.dart error');
                print(e.toString());
              }
            },
            child: Icon(Icons.logout_outlined),
          ),
        ],
      ),
    );
  }
}

class FeatureButton extends StatelessWidget {
  FeatureButton({
    super.key,
    required this.buttonName,
    required this.buttonIcon,
    required this.buttonRoute,
  });

  final String buttonName;
  final IconData buttonIcon;
  final Widget buttonRoute;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RawMaterialButton(
            onPressed: () {
              Get.to(() => buttonRoute, transition: Transition.noTransition);
            },
            fillColor: Color(0xFF3874CB),
            child: Icon(
              buttonIcon,
              color: Colors.white,
            ),
            padding: EdgeInsets.all(15.0),
            shape: CircleBorder(),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Text(
            buttonName,
            style: TextStyle(fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: StudentPage(),
  ));
}
