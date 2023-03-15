import 'dart:ui';
import 'package:ProFlow/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: notloading,
              child: Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    EmptyBox(),
                    Expanded(
                      child: SvgPicture.asset('assets/proflow.svg'),
                    ),
                    Expanded(
                        child: Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      width: MediaQuery.of(context).size.width * 0.8,
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
                    )),
                    EmptyBox(),
                    Expanded(
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            padding: const EdgeInsets.only(bottom: 40.0),
                            margin: const EdgeInsets.only(top: 0.0),
                            child: const FittedBox(
                                child: Text(
                              'Experience Redefined',
                              style: TextStyle(
                                color: Color.fromARGB(255, 187, 187, 187),
                                fontStyle: FontStyle.italic,
                              ),
                            )))),
                    Expanded(
                        child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: FittedBox(
                        child: ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              notloading = false;
                              loading = true;
                            });
                            try {
                              final GoogleUser = await GoogleSignIn().signIn();
                              final GoogleAuth =
                                  await GoogleUser!.authentication;
                              final credential = GoogleAuthProvider.credential(
                                accessToken: GoogleAuth.accessToken,
                                idToken: GoogleAuth.idToken,
                              );
                              final user = await FirebaseAuth.instance
                                  .signInWithCredential(credential);
                              final prefs =
                                  await SharedPreferences.getInstance();
                              final username =
                                  user.user?.displayName.toString();
                              await prefs.setString('username', username!);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => HomePage()));
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
                    )),
                    Expanded(
                      child: Container(),
                    )
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
