import 'package:ProFlow/appbar.dart';
import 'package:ProFlow/extensions.dart';
import 'package:ProFlow/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';

import 'expand.dart';

class ForumExp extends StatefulWidget {
  const ForumExp({super.key});

  @override
  State<ForumExp> createState() => _ForumExpState();
}

class _ForumExpState extends State<ForumExp> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          //error shit
          print('Sorry, you have run into an error. Please try again.');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          //loading forum
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final List ForumData = [];
        snapshot.data!.docs.map((DocumentSnapshot document) {
          Map catchdata = document.data() as Map<String, dynamic>;
          ForumData.add(catchdata);
          catchdata['id'] = document.id;
        }).toList();
        return Scaffold(
          appBar: ForumAppBar(),
          body: ListView(
            children: List.generate(
                ForumData.length,
                (index) => Column(
                      children: [
                        MsgCard(
                            ForumData: ForumData,
                            MsgController: TextEditingController(),
                            index: index)
                      ],
                    )),
          ),
        );
      },
    );
  }
}

class MsgCard extends StatefulWidget {
  final List ForumData;
  final dynamic index;
  final dynamic MsgController;
  const MsgCard(
      {required this.ForumData,
      required this.MsgController,
      required this.index});

  @override
  State<MsgCard> createState() => _MsgCardState(
      ForumData: this.ForumData,
      MsgController: this.MsgController,
      index: this.index);
}

class _MsgCardState extends State<MsgCard> {
  List ForumData;
  dynamic index;
  dynamic MsgController;

  _MsgCardState(
      {required this.ForumData,
      required this.MsgController,
      required this.index});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  SinglePost(index: index, MsgController: MsgController)),
        );
      },
      child: Card(
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.025,
          bottom: MediaQuery.of(context).size.height * 0.025,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(children: [
                Row(
                  children: [
                    Container(
                      width: 55.0.wp,
                      child: Text(
                        ForumData[index]['title'],
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.025,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                    FutureBuilder(
                      future: isAuthor(ForumData[index]['uid']),
                      builder: (context, snapshot) {
                        if (snapshot.data == true) {
                          return GestureDetector(
                            child: (Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                            onTap: () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Warning'),
                                content: const Text(
                                    'Are you sure you want to delete? This action cannot be undone.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      final id = ForumData[index]['id'];
                                      await FirebaseFirestore.instance
                                          .collection('posts')
                                          .doc(id)
                                          .delete();
                                      Navigator.pop(context, 'Ok');
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Placeholder(
                            strokeWidth: 0,
                            fallbackHeight: 0,
                            fallbackWidth: 0,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ]),
              SizedBox(height: 2.0.hp),
              Text(
                ForumData[index]['author'],
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.015),
              ),
              SizedBox(height: 3.0.hp),
              Container(
                child: Text(
                  ForumData[index]['content'],
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.017),
                  maxLines: 8,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Divider(
                color: Colors.black54,
                thickness: MediaQuery.of(context).size.height * 0.003,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LikePost(ForumData: ForumData, index: index),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                  Text(ForumData[index]['liked'].length.toString()),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                  Icon(
                    Icons.comment_rounded,
                    color: Colors.lightBlue,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                  Text(ForumData[index]['comments'].length.toString()),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Divider(
                color: Colors.black54,
                thickness: MediaQuery.of(context).size.height * 0.003,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              //comments column
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.height * 3.0,
                child: ListView(
                  children: List.generate(
                      ForumData[index]['comments'].length,
                      (commentindex) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    ForumData[index]['comments'][commentindex]
                                        ['author'],
                                    style: TextStyle(fontSize: 13),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01,
                                  ),
                                  Text(ForumData[index]['comments']
                                      [commentindex]['comment']),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.03,
                                  ),
                                ],
                              )
                            ],
                          )),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: MsgController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        labelText: 'Add a comment',
                      ),
                    ),
                  ),
                  SizedBox(width: 2.0.wp),
                  IconButton(
                      onPressed: () async {
                        //update comments
                        final prefs = await SharedPreferences.getInstance();
                        final username = await prefs.getString('username');
                        final firestore = await FirebaseFirestore.instance;
                        final uid = await prefs.getString('uid');
                        final uniqueid = ForumData[index]['uid'];
                        final id = ForumData[index]['id'];
                        final map = ForumData[index];
                        List comments = map['comments'];
                        comments.add({
                          "comment": MsgController.text,
                          "author": username,
                          "uid": uid
                        });
                        final author = map['author'];
                        final title = map['title'];
                        final content = map['content'];
                        List liked = map['liked'];
                        final doc = firestore.collection('posts').doc(id);
                        doc.update({
                          'uid': uniqueid,
                          'liked': liked,
                          'comments': comments,
                          'author': author,
                          'title': title,
                          'content': content
                        });
                        MsgController.clear();
                      },
                      icon: Icon(
                        Icons.send,
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> Like(ForumData, index) async {
  bool liked = false;
  final prefs = await SharedPreferences.getInstance();
  final uid = await prefs.getString('uid');
  for (String like in ForumData[index]['liked']) {
    if (like == uid) {
      liked = true;
    }
  }
  return liked;
}

class LikePost extends StatelessWidget {
  final ForumData;
  final index;
  const LikePost({super.key, required this.ForumData, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          final firestore = await FirebaseFirestore.instance;
          bool liked = false;
          final prefs = await SharedPreferences.getInstance();
          final uid = await prefs.getString('uid');
          for (String like in ForumData[index]['liked']) {
            if (like == uid) {
              liked = true;
            }
          }
          if (liked == false) {
            print('like');
            final uniqueid = ForumData[index]['uid'];
            final id = ForumData[index]['id'];
            final map = ForumData[index];
            final comments = map['comments'];
            final author = map['author'];
            final title = map['title'];
            final content = map['content'];
            List liked = map['liked'];
            liked.add(uid);
            final doc = firestore.collection('posts').doc(id);
            doc.update({
              'uid': uniqueid,
              'liked': liked,
              'comments': comments,
              'author': author,
              'title': title,
              'content': content
            });
          } else {
            print('unlike');
            final uniqueid = ForumData[index]['uid'];
            final id = ForumData[index]['id'];
            final map = ForumData[index];
            final comments = map['comments'];
            final author = map['author'];
            final title = map['title'];
            final content = map['content'];
            List liked = map['liked'];
            liked.removeAt(map['liked'].indexOf(uid));
            final doc = firestore.collection('posts').doc(id);
            doc.update({
              'uid': uniqueid,
              'liked': liked,
              'comments': comments,
              'author': author,
              'title': title,
              'content': content
            });
          }
          ;
        },
        child: FutureBuilder(
          future: Like(ForumData, index),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Icon(Icons.favorite, color: Colors.grey);
            }
            if (snapshot.data == true) {
              return Icon(Icons.favorite, color: Colors.red);
            } else {
              return Icon(Icons.favorite, color: Colors.grey);
            }
          },
        ));
  }
}

Future<bool> isAuthor(uidAuthor) async {
  final prefs = await SharedPreferences.getInstance();
  final uid = await prefs.getString('uid');
  print('uid: ' + uid! + " author's uid: " + uidAuthor);
  if (uid == uidAuthor) {
    return true;
  } else {
    return false;
  }
}

class Post extends StatefulWidget {
  const Post({super.key});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  var title = "My Amazing Title";
  var content = "Write Something Special!";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create a post"),
      ),
      body: ListView(
          padding: EdgeInsets.only(
            left: 10.0.wp,
            right: 10.0.wp,
            bottom: 10.0.hp,
          ),
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10.0.wp),
                TextFormField(
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(10.0),
                  )),
                  initialValue: 'My Amazing Title',
                  onChanged: (value) {
                    title = value;
                  },
                ),
                SizedBox(
                  height: 5.0.wp,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('We recommend you keep it short and sweet.'),
                ),
                SizedBox(
                  height: 5.0.hp,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(8.0),
                  )),
                  initialValue: 'Write Something Special!',
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onChanged: (value) {
                    content = value;
                  },
                ),
                SizedBox(
                  height: 5.0.wp,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Ask a question or share your views here!'),
                ),
                SizedBox(
                  height: 6.0.hp,
                ),
                ElevatedButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      Navigator.of(context).pop();
                      final author = await prefs.getString('username');
                      final uid = await prefs.getString('uid');
                      await FirebaseFirestore.instance.collection('posts').add({
                        'title': title,
                        'author': author,
                        'content': content,
                        'uid': uid,
                        'liked': [],
                        'comments': []
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.all(2.0.wp),
                      child: Text(
                        'Post',
                        style: TextStyle(
                          fontSize: 15.0.sp,
                        ),
                      ),
                    )),
                SizedBox(
                  height: 3.0.hp,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text('Be sure to do one last check!'),
                ),
              ],
            ),
          ]),
    );
  }
}

class ForumAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ForumAppBar({super.key});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Forum'),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Post()));
          },
          icon: Icon(Icons.add),
        )
      ],
      automaticallyImplyLeading: true,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(
              context, MaterialPageRoute(builder: ((context) => HomePage())));
        },
        icon: const Icon(Icons.home),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
