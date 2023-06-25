import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:ProFlow/utils.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home_page.dart';
import 'newhomepage.dart';

class Scene extends StatefulWidget {
  const Scene({super.key});

  @override
  State<Scene> createState() => _SceneState();
}

class _SceneState extends State<Scene> {
  bool notloading = true;
  bool loading = false;
  @override
Widget build(BuildContext context) {
    double baseWidth = 430;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Container(
      width: double.infinity,
      child: Container(
        // loginscreenPBL (3:2)
        padding: EdgeInsets.fromLTRB(82 * fem, 217 * fem, 82 * fem, 296 * fem),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xffffffff),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // logohhp (3:5)
              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 2 * fem, 21 * fem),
              width: 178 * fem,
              height: 178 * fem,
              child: Image.asset(
                'assets/logo-ZUa.png',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              // proflowpGe (3:3)
              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 2 * fem, 17 * fem),
              child: Text(
                'Proflow',
                style: SafeGoogleFont(
                  'Inter',
                  fontSize: 36 * ffem,
                  fontWeight: FontWeight.w700,
                  height: 1.2125 * ffem / fem,
                  color: Color(0xff000000),
                ),
              ),
            ),
            Container(
              // experienceredefinedXRx (3:6)
              margin: EdgeInsets.fromLTRB(0 * fem, 0 * fem, 1 * fem, 56 * fem),
              child: Text(
                'Experience Redefined.',
                textAlign: TextAlign.center,
                style: SafeGoogleFont(
                  'Inter',
                  fontSize: 24 * ffem,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic,
                  height: 1.2125 * ffem / fem,
                  color: Color(0xff000000),
                ),
              ),
            ),
            TextButton(
              // loginbuttoncyC (18:45)
              onPressed: () async {
                setState(() {
                  notloading = false;
                  loading = true;
                });
                try {
                  //hi
                  final GoogleUser = await GoogleSignIn().signIn();
                  final GoogleAuth = await GoogleUser!.authentication;
                  final credential = GoogleAuthProvider.credential(
                    accessToken: GoogleAuth.accessToken,
                    idToken: GoogleAuth.idToken,
                  );
                  final user = await FirebaseAuth.instance
                      .signInWithCredential(credential);
                  //student teacher
                  final email = await GoogleUser.email;
                  final username =
                      await FirebaseAuth.instance.currentUser!.displayName;
                  final prefs = await SharedPreferences.getInstance();
                  final uid = await FirebaseAuth.instance.currentUser!.uid;
                  await prefs.setString('uid', uid);
                  await prefs.setString('username', username!);
                  await prefs.setString('email', email);
                  bool containsuid = false;
                  await FirebaseFirestore.instance
                      .collection('identity')
                      .get()
                      .then((identityValue) => {
                            for (final doc in identityValue.docs)
                              {
                                if (doc.data().values.contains(uid))
                                  {
                                    containsuid = true,
                                    prefs.setString(
                                        'identity', doc.data()['identity'])
                                  }
                              },
                            if (containsuid == false)
                              {
                                print('registering'),
                                //dont hv the guy in database
                                if (RegExp(r'(\d)').hasMatch(email))
                                  {
                                    print('student'),
                                    //student(contains digits)
                                    prefs.setString('identity', 'student'),
                                    FirebaseFirestore.instance
                                        .collection('identity')
                                        .add(
                                            {'uid': uid, 'identity': 'student'})
                                  }
                                else
                                  {
                                    //teacher
                                    print('not student'),
                                    prefs.setString('identity', 'teacher'),
                                    FirebaseFirestore.instance
                                        .collection('identity')
                                        .add(
                                            {'uid': uid, 'identity': 'teacher'})
                                  }
                              },
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => HomePage()))
                          });
                } on FirebaseAuthException catch (e) {
                  print(e.toString());
                  loading = false;
                  notloading = true;
                  return null;
                } catch (e) {
                  print(e);
                  loading = false;
                  notloading = true;
                  return null;
                } on PlatformException catch (e) {
                  loading = false;
                  notloading = true;
                  return null;
                }
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              child: Container(
                width: double.infinity,
                height: 73 * fem,
                decoration: BoxDecoration(
                  color: Color(0xff3874cb),
                  borderRadius: BorderRadius.circular(13 * fem),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x3f000000),
                      offset: Offset(0 * fem, 4 * fem),
                      blurRadius: 2 * fem,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Log In',
                    style: SafeGoogleFont(
                      'Inter',
                      fontSize: 24 * ffem,
                      fontWeight: FontWeight.w700,
                      height: 1.2125 * ffem / fem,
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}