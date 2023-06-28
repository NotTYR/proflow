import 'package:ProFlow/appbar.dart';
import 'package:ProFlow/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';

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
                        Card(
                          margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.025,
                            bottom: MediaQuery.of(context).size.height * 0.025,
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.1),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(children: [
                                  Row(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.55,
                                        child: Text(
                                          ForumData[index]['title'],
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.03,
                                            overflow: TextOverflow.ellipsis,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                      ),
                                      FutureBuilder(
                                        future:
                                            isAuthor(ForumData[index]['uid']),
                                        builder: (context, snapshot) {
                                          if (snapshot.data == true) {
                                            return GestureDetector(
                                              child: (Icon(
                                                Icons.delete,
                                                color: Colors.green,
                                              )),
                                              onTap: () async {
                                                final id =
                                                    ForumData[index]['id'];
                                                await FirebaseFirestore.instance
                                                    .collection('posts')
                                                    .doc(id)
                                                    .delete();
                                              },
                                            );
                                          } else {
                                            return Placeholder();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ]),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.05),
                                Text(
                                  ForumData[index]['author'],
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.025),
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.08),
                                Text(ForumData[index]['content']),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.05),
                                Divider(
                                  color: Colors.black54,
                                  thickness:
                                      MediaQuery.of(context).size.height *
                                          0.003,
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.02),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                        onTap: () async {
                                          final firestore =
                                              await FirebaseFirestore.instance;
                                          bool liked = false;
                                          final prefs = await SharedPreferences
                                              .getInstance();
                                          final uid =
                                              await prefs.getString('uid');
                                          for (String like in ForumData[index]
                                              ['liked']) {
                                            if (like == uid) {
                                              liked = true;
                                            }
                                          }
                                          if (liked == false) {
                                            print('like');
                                            final id = ForumData[index]['id'];
                                            final map = ForumData[index];
                                            final comments = map['comments'];
                                            final author = map['author'];
                                            final title = map['title'];
                                            final content = map['content'];
                                            List liked = map['liked'];
                                            liked.add(uid);
                                            final doc = firestore
                                                .collection('posts')
                                                .doc(id);
                                            doc.update({
                                              'uid': uid,
                                              'liked': liked,
                                              'comments': comments,
                                              'author': author,
                                              'title': title,
                                              'content': content
                                            });
                                          } else {
                                            print('unlike');
                                            final id = ForumData[index]['id'];
                                            final map = ForumData[index];
                                            final comments = map['comments'];
                                            final author = map['author'];
                                            final title = map['title'];
                                            final content = map['content'];
                                            List liked = map['liked'];
                                            liked.removeAt(
                                                map['liked'].indexOf(uid));
                                            final doc = firestore
                                                .collection('posts')
                                                .doc(id);
                                            doc.update({
                                              'uid': uid,
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
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Icon(Icons.favorite,
                                                  color: Colors.grey);
                                            }
                                            if (snapshot.data == true) {
                                              return Icon(Icons.favorite,
                                                  color: Colors.red);
                                            } else {
                                              return Icon(Icons.favorite,
                                                  color: Colors.grey);
                                            }
                                          },
                                        )),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.01),
                                    Text(ForumData[index]['liked']
                                        .length
                                        .toString()),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.05),
                                    Icon(
                                      Icons.comment_rounded,
                                      color: Colors.lightBlue,
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.01),
                                    Text(ForumData[index]['comments']
                                        .length
                                        .toString()),
                                  ],
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.03),
                                Divider(
                                  color: Colors.black54,
                                  thickness:
                                      MediaQuery.of(context).size.height *
                                          0.003,
                                ),
                                Column(),
                                TextFormField(
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1.5),
                                      borderRadius: BorderRadius.circular(20.0),
                                    )))
                              ],
                            ),
                          ),
                        )
                      ],
                    )),
          ),
        );
      },
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

Future<bool> isAuthor(uidAuthor) async {
  final prefs = await SharedPreferences.getInstance();
  final uid = await prefs.getString('uid');
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
      body: ListView(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Text(
                  'Create a post',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.sizeOf(context).shortestSide * 0.1),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(10.0),
                  )),
                  initialValue: 'My Amazing Title',
                  onChanged: (value) {
                    title = value;
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(10.0),
                  )),
                  initialValue: 'Write Something Special!',
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onChanged: (value) {
                    content = value;
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
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
                    child: Text('Post'))
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
      title: Text('ProFlow'),
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
