import 'package:ProFlow/extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'forum.dart';

class SinglePost extends StatefulWidget {
  final index;
  const SinglePost({super.key, required this.index});

  @override
  State<SinglePost> createState() => _SinglePostState(index: index);
}

class _SinglePostState extends State<SinglePost> {
  dynamic index;
  _SinglePostState({required this.index});
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
            forumdata: ForumData[index], index: index, rawforumdata: ForumData);
      },
    );
  }
}

class ExpandedPost extends StatefulWidget {
  final index;
  final Map forumdata;
  final rawforumdata;
  const ExpandedPost(
      {super.key,
      required this.forumdata,
      required this.index,
      required this.rawforumdata});

  @override
  State<ExpandedPost> createState() => _ExpandedPostState(
      forumdata: forumdata, index: index, rawforumdata: rawforumdata);
}

class _ExpandedPostState extends State<ExpandedPost> {
  dynamic rawforumdata;
  Map forumdata;
  dynamic index;
  _ExpandedPostState(
      {required this.forumdata,
      required this.index,
      required this.rawforumdata});
  @override
  Widget build(BuildContext context) {
    if (forumdata.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(forumdata['title']),
        ),
        body: Scaffold(
          body: Padding(
            padding: EdgeInsets.only(
              left: 6.0.wp,
              right: 6.0.wp,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 3.0.hp,
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
                                        final id = forumdata['id'];
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
                  SizedBox(height: 2.0.hp),
                  Text(
                    forumdata['author'],
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.015),
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
                      SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                      Text(rawforumdata[index]['liked'].length.toString()),
                    ],
                  ),
                  SizedBox(
                    height: 2.0.hp,
                  ),
                  Divider(
                    color: Colors.black54,
                    thickness: MediaQuery.of(context).size.height * 0.003,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  SizedBox(height: 3.0.hp),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }
}
