import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> CheckForProjects() async {
  final prefs = await SharedPreferences.getInstance();
  final uid = await prefs.getString('uid');
  String returnbool = 'false';
  await FirebaseFirestore.instance
      .collection('propose')
      .get()
      .then((values) => {
            for (final value in values.docs)
              {
                if (value.data().values.contains(uid)) {returnbool = 'true'}
              }
          });
  return returnbool;
}

void Propose() async {
  print('proposing');
  final prefs = await SharedPreferences.getInstance();
  final uid = await prefs.getString('uid');
  final email = await prefs.getString('email');
  await FirebaseFirestore.instance.collection('propose').add({
    'description': 'pw for pw',
    'email': email,
    'preferred': ['dr chia', 'nobody else'],
    'title': 'ProFlow',
    'uid': uid
  });
}
