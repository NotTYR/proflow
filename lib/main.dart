import 'package:firebase_core/firebase_core.dart';
import 'guest_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'package:flutter/services.dart';

void main() async {
  //widgets??
  WidgetsFlutterBinding.ensureInitialized();
  //firebase
  await Firebase.initializeApp(
  );
  //technically portrait mode not wokring
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) => runApp(MaterialApp(
            title: 'ProFlow',
            home: StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (BuildContext context, snapshot) {
                  print('test');
                  if (snapshot.hasData) {
                    //logged in
                    return HomePage();
                  } else {
                    print('gp');
                    // not logged in
                    return GuestPage();
                  }
                }),
          )));
}
