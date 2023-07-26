import 'package:ProFlow/extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:ProFlow/appbar.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
        appBar: ProFlowAppBar(title: 'Groups'),
        body: Column(
          children: [
            ElevatedButton(
                onPressed: () async {
                  final doc = await GetDocUid();
                  if (doc == 'placeholder') {
                    SharedPreferences data =
                        await SharedPreferences.getInstance();
                    data.setInt("checkGroup", 1);

                    final prefs = await SharedPreferences.getInstance();
                    final uid = prefs.getString('uid');
                    final firebase = FirebaseFirestore.instance;
                    firebase.collection('groups').add({
                      'task': [],
                      'members': [uid]
                    });
                    String newdocid = await GetDocUid();
                    setState(() {
                      controlled = ('Group created. ID: ' + newdocid);
                    });
                  } else {
                    String newdocid = await GetDocUid();
                    setState(() {
                      controlled =
                          ('You are already in a group. ID: ' + newdocid);
                    });
                  }
                },
                child: Text('create group')),
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
                child: Text('join group')),
            Text(controlled)
          ],
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
      body: Column(
        children: [
          TextFormField(
            controller: controller,
          ),
          ElevatedButton(
              onPressed: () async {
                final firestore = await FirebaseFirestore.instance;
                var success = null;
                String control = 'LK1MIg5fpwD3u9s0gS4I';
                final prefs = await SharedPreferences.getInstance();
                final uid = await prefs.getString('uid');
                await firestore
                    .collection('groups')
                    .doc(control)
                    .get()
                    .then((doc) async {
                  if (doc.exists) {
                    SharedPreferences data =
                        await SharedPreferences.getInstance();
                    data.setInt("checkGroup", 1);

                    success = true;
                    print('join');
                    final docs =
                        await firestore.collection('groups').doc(control).get();
                    final members = docs.data()?['members'];
                    members.add(uid);
                    await firestore
                        .collection('groups')
                        .doc(control)
                        .update({"members": members});
                    controlled = 'Joined';
                  } else {
                    success = false;
                    controlled = 'Invalid';
                  }
                });
              },
              child: Text('Join')),
          Text(controlled)
        ],
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
