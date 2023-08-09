import 'package:ProFlow/extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
