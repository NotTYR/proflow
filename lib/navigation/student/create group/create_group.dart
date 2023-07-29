import 'package:ProFlow/extensions.dart';
import 'package:ProFlow/navigation/student/homepage.dart';
import 'package:ProFlow/navigation/student/onboarding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ProFlow/appbar.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onboarding/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../guest_page.dart';
import '../my project/core/values/colors.dart';
import '../my project/data/models/task.dart';
import '../my project/modules/home/controller.dart';
import '../my project/modules/widgets/icons.dart';

class ProposalPage extends StatefulWidget {
  ProposalPage({super.key});

  @override
  State<ProposalPage> createState() => _ProposalPageState();
}

//TODO: Change FutureBuilder to StreamBuilder so that it can continuously listen to changes
class _ProposalPageState extends State<ProposalPage> {
  String controlled = '';
  @override
  Widget build(BuildContext context) {
    var squareWidth = Get.width - 12.0.wp;
    return Scaffold(
        body: Container(
          padding: EdgeInsets.only(
            top: 4.0.hp,
            bottom: 4.0.hp,
            left: 6.0.wp,
            right: 6.0.wp,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                    bottom: 3.0.hp,
                  ),
                  child: const FittedBox(
                      child: Text(
                    'Experience Redefined',
                    style: TextStyle(
                      color: Color.fromARGB(255, 187, 187, 187),
                      fontStyle: FontStyle.italic,
                    ),
                  ))),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.0.hp),
                  Text(
                      'You need to be in a group to use the features of ProFlow.'),
                  SizedBox(height: 2.0.hp),
                  Text(
                      'If you are the leader of your group, you may begin by clicking Create Group. Otherwise, click on Join Group and enter the code that is shared by your group leader'),
                  SizedBox(height: 5.0.hp),
                ],
              ),
              ElevatedButton(
                  onPressed: () async {
                    final doc = await GetDocUid();
                    if (doc == 'placeholder') {
                      final prefs = await SharedPreferences.getInstance();
                      final uid = prefs.getString('uid');
                      final firebase = FirebaseFirestore.instance;
                      await firebase.collection('groups').add({
                        'task': [],
                        'members': [uid]
                      });
                      String newdocid = await GetDocUid();
                      // setState(() {
                      //   controlled = ('Group created. ID: ' + newdocid);
                      // });
                      showDialog<void>(
                        context: context,
                        barrierDismissible: false, // user must tap button
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Create Success'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text(
                                      'Share the following code with your members: ' +
                                          newdocid),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child:
                                    const Text('Copy to clipboard and proceed'),
                                onPressed: () {
                                  Clipboard.setData(
                                      ClipboardData(text: newdocid));
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OnboardingPage()),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      String newdocid = await GetDocUid();
                      setState(() {
                        controlled =
                            ("This should not be possible LMAO but you're already in a group: " +
                                newdocid);
                      });
                    }
                  },
                  child: Text('Create group')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => JoinGroup(
                                  controller: TextEditingController(),
                                )));
                    //go to another page, input textfield, button to confirm, check if collection.doc(input) exist
                  },
                  child: Text('Join group')),
              SizedBox(height: 2.0.hp),
              Text(controlled),
            ],
          ),
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

class JoinGroup extends StatefulWidget {
  final controller;
  const JoinGroup({super.key, required this.controller});

  @override
  State<JoinGroup> createState() =>
      _JoinGroupState(controller: this.controller);
}

class _JoinGroupState extends State<JoinGroup> {
  var controlled = '';
  final controller;
  _JoinGroupState({required this.controller});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProFlowAppBar(title: 'Join Group'),
      body: Padding(
        padding: EdgeInsets.only(
          left: 6.0.wp,
          right: 6.0.wp,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Enter the code provided by your group leader.'),
            SizedBox(height: 2.0.hp),
            TextFormField(
              controller: controller,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.0.hp),
            ElevatedButton(
                onPressed: () async {
                  final firestore = await FirebaseFirestore.instance;
                  var success = null;
                  final prefs = await SharedPreferences.getInstance();
                  final uid = await prefs.getString('uid');
                  print(controller.text);
                  bool groupexists = false;
                  final groups = await firestore.collection('groups').get();
                  for (var group in groups.docs) {
                    print(group.id);
                    if (group.id == controller.text) {
                      groupexists = true;
                    }
                  }
                  if (groupexists == true) {
                    success = true;
                    print('join');
                    final docs = await firestore
                        .collection('groups')
                        .doc(controller.text)
                        .get();
                    final members = docs.data()?['members'];
                    members.add(uid);
                    await firestore
                        .collection('groups')
                        .doc(controller.text)
                        .update({"members": members});
                    setState(() {
                      controlled = '';
                    });
                    showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Join Success'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text('Group ID: ' + controller.text),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Proceed'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OnboardingPage()),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    success = false;
                    setState(() {
                      controlled = 'Invalid ID.';
                    });
                  }
                },
                child: Text('Join')),
            SizedBox(height: 3.0.hp),
            Text(controlled),
            SizedBox(height: 6.0.hp),
          ],
        ),
      ),
    );
  }
}

Future<String> GetDocUid() async {
  final prefs = await SharedPreferences.getInstance();
  final uid = await prefs.getString('uid');
  final firestore = FirebaseFirestore.instance;
  final groups = await firestore.collection('groups').get();
  for (var group in groups.docs) {
    if (group.data()['members'].contains(uid)) {
      return group.id;
    }
  }
  print('not in a group');
  return 'placeholder';
}
