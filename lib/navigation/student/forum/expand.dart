import 'package:ProFlow/extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'forum.dart';

class SinglePost extends StatefulWidget {
  final index;
  final MsgController;
  const SinglePost(
      {super.key, required this.index, required this.MsgController});

  @override
  State<SinglePost> createState() =>
      _SinglePostState(index: index, MsgContoller: MsgController);
}

class _SinglePostState extends State<SinglePost> {
  dynamic index;
  dynamic MsgContoller;
  _SinglePostState({required this.index, required this.MsgContoller});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        final List ForumData = [];
        snapshot.data!.docs.map((DocumentSnapshot document) {
          Map catchdata = document.data() as Map<String, dynamic>;
          ForumData.add(catchdata);
          catchdata['id'] = document.id;
        }).toList();
        return ExpandedPost(
          forumdata: ForumData[index],
          index: index,
          rawforumdata: ForumData,
          MsgController: MsgContoller,
        );
      },
    );
  }
}

class ExpandedPost extends StatefulWidget {
  final index;
  final Map forumdata;
  final MsgController;
  final rawforumdata;
  const ExpandedPost(
      {super.key,
      required this.MsgController,
      required this.forumdata,
      required this.index,
      required this.rawforumdata});

  @override
  State<ExpandedPost> createState() => _ExpandedPostState(
      forumdata: forumdata,
      index: index,
      rawforumdata: rawforumdata,
      MsgContoller: MsgController);
}

class _ExpandedPostState extends State<ExpandedPost> {
  dynamic rawforumdata;
  dynamic MsgContoller;
  Map forumdata;
  dynamic index;
  _ExpandedPostState(
      {required this.MsgContoller,
      required this.forumdata,
      required this.index,
      required this.rawforumdata});
  @override
  Widget build(BuildContext context) {
    if (forumdata.isNotEmpty) {
      return Scaffold(
        // appBar: AppBar(
        //   title: Text(forumdata['title']),
        // ),
        body: Scaffold(
          body: Column(
            children: [
              SizedBox(height: 7.0.hp),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.0.wp),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 8.0.wp,
                  right: 8.0.wp,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 2.0.hp,
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              forumdata['title'],
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.025,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.0.wp,
                          ),
                          FutureBuilder(
                            future: isAuthor(forumdata['uid']),
                            builder: (context, snapshot) {
                              if (snapshot.data == true) {
                                return GestureDetector(
                                  child: (Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  )),
                                  onTap: () => showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
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
                                            final id = forumdata['id'];
                                            await FirebaseFirestore.instance
                                                .collection('posts')
                                                .doc(id)
                                                .delete();
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ForumExp(),
                                              ),
                                            );
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
                      SizedBox(height: 2.0.hp),
                      Text(
                        forumdata['author'],
                        style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height * 0.015),
                      ),
                      SizedBox(height: 3.0.hp),
                      Text(
                        forumdata['content'],
                      ),
                      SizedBox(
                        height: 3.0.hp,
                      ),
                      Divider(
                        color: Colors.black54,
                        thickness: MediaQuery.of(context).size.height * 0.003,
                      ),
                      SizedBox(
                        height: 2.0.hp,
                      ),
                      Row(
                        children: [
                          LikePost(ForumData: rawforumdata, index: index),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.01),
                          Text(rawforumdata[index]['liked'].length.toString()),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.05),
                          Icon(
                            Icons.comment_rounded,
                            color: Colors.lightBlue,
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.01),
                          Text(rawforumdata[index]['comments']
                              .length
                              .toString()),
                        ],
                      ),
                      SizedBox(
                        height: 2.0.hp,
                      ),
                      Divider(
                        color: Colors.black54,
                        thickness: MediaQuery.of(context).size.height * 0.003,
                      ),
                      //comments column
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                        width: MediaQuery.of(context).size.height * 3.0,
                        child: ListView(
                          children: List.generate(
                              rawforumdata[index]['comments'].length,
                              (commentindex) => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            rawforumdata[index]['comments']
                                                [commentindex]['author'],
                                            style: TextStyle(fontSize: 13),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01,
                                          ),
                                          Text(rawforumdata[index]['comments']
                                              [commentindex]['comment']),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
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
                            child: TextField(
                              controller: MsgContoller,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: InputDecoration(
                                labelText: 'Add a comment',
                                // enabledBorder: OutlineInputBorder(
                                //   borderSide:
                                //       BorderSide(color: Colors.black, width: 1.5),
                                //   borderRadius: BorderRadius.circular(20.0),
                                // ),
                              ),
                            ),
                          ),
                          SizedBox(width: 2.0.wp),
                          IconButton(
                              onPressed: () async {
                                //update comments
                                final prefs =
                                    await SharedPreferences.getInstance();
                                final username =
                                    await prefs.getString('username');
                                final firestore =
                                    await FirebaseFirestore.instance;
                                final uid = await prefs.getString('uid');
                                final uniqueid = rawforumdata[index]['uid'];
                                final id = rawforumdata[index]['id'];
                                final map = rawforumdata[index];
                                List comments = map['comments'];
                                comments.add({
                                  "comment": MsgContoller.text,
                                  "author": username,
                                  "uid": uid
                                });
                                final author = map['author'];
                                final title = map['title'];
                                final content = map['content'];
                                List liked = map['liked'];
                                final doc =
                                    firestore.collection('posts').doc(id);
                                doc.update({
                                  'uid': uniqueid,
                                  'liked': liked,
                                  'comments': comments,
                                  'author': author,
                                  'title': title,
                                  'content': content
                                });
                                MsgContoller.clear();
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
            ],
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }
}
