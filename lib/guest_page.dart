import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_page.dart';
import 'invalid_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ProFlow/extensions.dart';
import 'sign_out.dart';
import 'main.dart';

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
                              bottom: 8.0.hp,
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
                                  var GoogleUser =
                                      await GoogleSignIn().signIn();
                                  var GoogleAuth =
                                      await GoogleUser!.authentication;
                                  var email = await GoogleUser.email;
                                  print(email);
                                  if (RegExp(r'(\@student.hci.edu.sg)')
                                      .hasMatch(email.toString())) {
                                    print('hci email');
                                    final credential =
                                        GoogleAuthProvider.credential(
                                      accessToken: GoogleAuth.accessToken,
                                      idToken: GoogleAuth.idToken,
                                    );
                                    await FirebaseAuth.instance
                                        .signInWithCredential(credential);
                                    //student teacher
                                    final username = await FirebaseAuth
                                        .instance.currentUser!.displayName;
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    final uid = await FirebaseAuth
                                        .instance.currentUser!.uid;
                                    print('username' + username!);
                                    print('uid' + uid);
                                    print('email' + email);
                                    await prefs.setString('uid', uid);
                                    await prefs.setString('username', username);
                                    await prefs.setString('email', email);
                                    bool containsuid = false;
                                    print('still fine here :) guset_page.dart');
                                    await FirebaseFirestore.instance
                                        .collection('identity')
                                        .get()
                                        .then((identityValue) => {
                                              for (final doc
                                                  in identityValue.docs)
                                                {
                                                  if (doc
                                                      .data()
                                                      .values
                                                      .contains(uid))
                                                    {containsuid = true}
                                                },
                                              print(
                                                  'im fine here :) guest_page.dart'),
                                              if (containsuid == false)
                                                {
                                                  print('registering'),
                                                  {
                                                    prefs.setString(
                                                        'identity', 'student'),
                                                    FirebaseFirestore.instance
                                                        .collection('identity')
                                                        .add({
                                                      'uid': uid,
                                                      'username': username
                                                    })
                                                  }
                                                },
                                              loading = false,
                                              notloading = true,
                                              print(
                                                  'wippe no error in guest_page.dart'),
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          HomePage()))
                                            });
                                  } else {
                                    signOut(context, InvalidLogin());
                                  }
                                } on FirebaseAuthException catch (e) {
                                  print('firebaseauth error. guest_page.dart');
                                  print(e.toString());
                                  loading = false;
                                  notloading = true;
                                  return null;
                                } catch (e) {
                                  print('idkwhat error. guest_page.dart');
                                  print(e);
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
