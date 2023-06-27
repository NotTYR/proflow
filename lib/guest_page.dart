import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GuestPage extends StatefulWidget {
  const GuestPage({super.key});

  @override
  State<GuestPage> createState() => _GuestPageState();
}

class _GuestPageState extends State<GuestPage> {
  bool notloading = true;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: notloading,
                  child: Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                          Container(
                            child: SvgPicture.asset('assets/proflow.svg'),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            margin: const EdgeInsets.only(
                              top: 40.0,
                              bottom: 25.0,
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
                                margin: const EdgeInsets.only(
                                  bottom: 60.0,
                                ),
                                child: const FittedBox(
                                    child: Text(
                                  'Experience Redefined',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 187, 187, 187),
                                    fontStyle: FontStyle.italic,
                                  ),
                                ))),
                          Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: FittedBox(
                            child: ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  notloading = false;
                                  loading = true;
                                });
                                try {
                                  //hi
                                  final GoogleUser =
                                      await GoogleSignIn().signIn();
                                  final GoogleAuth =
                                      await GoogleUser!.authentication;
                                  final credential =
                                      GoogleAuthProvider.credential(
                                    accessToken: GoogleAuth.accessToken,
                                    idToken: GoogleAuth.idToken,
                                  );
                                  final user = await FirebaseAuth.instance
                                      .signInWithCredential(credential);
                                  //student teacher
                                  final email = await GoogleUser.email;
                                  final username = await FirebaseAuth
                                      .instance.currentUser!.displayName;
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  final uid = await FirebaseAuth
                                      .instance.currentUser!.uid;
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
                                                if (doc
                                                    .data()
                                                    .values
                                                    .contains(uid))
                                                  {
                                                    containsuid = true,
                                                    prefs.setString('identity',
                                                        doc.data()['identity'])
                                                  }
                                              },
                                            if (containsuid == false)
                                              {
                                                print('registering'),
                                                //dont hv the guy in database
                                                if (RegExp(r'(\d)')
                                                    .hasMatch(email))
                                                  {
                                                    print('student'),
                                                    //student(contains digits)
                                                    prefs.setString(
                                                        'identity', 'student'),
                                                    FirebaseFirestore.instance
                                                        .collection('identity')
                                                        .add({
                                                      'uid': uid,
                                                      'identity': 'student'
                                                    })
                                                  }
                                                else
                                                  {
                                                    //teacher
                                                    print('not student'),
                                                    prefs.setString(
                                                        'identity', 'teacher'),
                                                    FirebaseFirestore.instance
                                                        .collection('identity')
                                                        .add({
                                                      'uid': uid,
                                                      'identity': 'teacher'
                                                    })
                                                  }
                                              },
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomePage()))
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
                              child: Text('LOG IN'),
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColorDark,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                    visible: loading,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmptyBox extends StatelessWidget {
  const EmptyBox({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.1,
    );
  }
}
