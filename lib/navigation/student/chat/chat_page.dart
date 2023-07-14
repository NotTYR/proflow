import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('messages').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        List Chats = snapshot.data!.docs.map((DocumentSnapshot document) {
          Map catchdata = document.data() as Map<String, dynamic>;
          catchdata['id'] = document.id;
          return catchdata;
        }).toList();
        return FutureBuilder(
            future: GetUid(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                bool InChat = false;
                String id = '';
                for (Map chat in Chats) {
                  final users = chat['users'];
                  for (final user in users) {
                    //snapshot.data stands for uid
                    if (user == snapshot.data) {
                      InChat = true;
                      id = chat['id'];
                    }
                  }
                }
                if (InChat == false) {
                  return Center(
                    child: Text('Join A Project!'),
                  );
                } else {
                  for (Map chat in Chats) {
                    if (chat['id'] == id) {
                      return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('messages')
                            .doc(id)
                            .collection('messages')
                            .snapshots(),
                        builder: (context, snapshot) {
                          print('messages');
                          print(snapshot.data);
                          List Messages = [];
                          if (snapshot.hasData) {
                            Messages = snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              Map catchdata =
                                  document.data() as Map<String, dynamic>;
                              Messages.add(catchdata);
                            }).toList();
                          }
                          return Scaffold(
                            body: ListView(
                                children: List.generate(
                                    Messages.length,
                                    (index) => Column(
                                          children: [],
                                        ))),
                          );
                        },
                      );
                    }
                  }
                  return Text(
                      'An Error has occurred. Your luck is so bad you have caught an imaginary error.');
                }
              }
            });
      },
    );
  }
}

Future<String> GetUid() async {
  final prefs = await SharedPreferences.getInstance();
  final uid = await prefs.getString('uid');
  if (uid != null) {
    return uid;
  } else {
    return '';
  }
}
