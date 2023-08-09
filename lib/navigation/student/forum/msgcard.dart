import 'package:ProFlow/extensions.dart';
import 'package:ProFlow/navigation/student/forum/view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'expand.dart';

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
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.1,
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: ForumData[index]['comments'].length,
                  itemBuilder: (context, commentIndex) {
                    final comment = ForumData[index]['comments'][commentIndex];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          comment['author'],
                          style:
                              TextStyle(fontSize: 13, color: Colors.grey[500]),
                        ),
                        SizedBox(height: 0.5.hp),
                        Text(
                          comment['comment'],
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(height: 2.0.hp),
                      ],
                    );
                  },
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
