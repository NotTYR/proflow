import 'package:flutter_svg/flutter_svg.dart';

import 'navigation/find_mentor.dart';
import 'navigation/forum.dart';
import 'navigation/my_projects.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'guest_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
              margin: const EdgeInsets.only(bottom: 50.0),
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
            SizedBox(
              height: 70.0,
              child: FeatureButton(
                  buttonName: 'Forum',
                  buttonIcon: Icons.chat,
                  buttonRoute: ForumExp()),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            try {
              await FirebaseAuth.instance.signOut();
              await GoogleSignIn().signOut();
              Navigator.push(context,
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
    return ElevatedButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => buttonRoute));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(buttonIcon),
            Text(
              buttonName,
              style: TextStyle(),
            )
          ],
        ));
  }
}
