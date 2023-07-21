import 'package:ProFlow/extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'forum.dart';

class ExpandedPost extends StatefulWidget {
  final dynamic forumdata;
  const ExpandedPost({super.key, required this.forumdata});

  @override
  State<ExpandedPost> createState() => _ExpandedPostState(forumdata: forumdata);
}

class _ExpandedPostState extends State<ExpandedPost> {
  dynamic forumdata;
  _ExpandedPostState({required this.forumdata});
  @override
  Widget build(BuildContext context) {
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
                SizedBox(height: 3.0.hp,),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        forumdata['title'],
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.025,
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
                SizedBox(height: 3.0.hp,),
                Divider(
                  color: Colors.black54,
                  thickness: MediaQuery.of(context).size.height * 0.003,
                ),
                SizedBox(
                  height: 2.0.hp,
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
  }
}
