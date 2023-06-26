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
          catchdata['id'] = 'posts';
        }).toList();
        return Scaffold(
          appBar: ProFlowAppBar(),
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
                            width: MediaQuery.of(context).size.width * 0.7,
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.1),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  ForumData[index]['title'],
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.03),
                                Text(ForumData[index]['author']),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.02),
                                Text(ForumData[index]['content']),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.02),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        final prefs =
                                            await FirebaseFirestore.instance;
                                        //TODO: ADD LIKES TRY TO FIND PATH TO LIKES
                                      },
                                      child: Icon(
                                        Icons.favorite,
                                        color: Colors.pink,
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.01),
                                    Text(
                                      ForumData[index]['likes'].toString(),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    )),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Post()));
            },
            child: Icon(Icons.add),
          ),
        );
      },
    );
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
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ForumExp()));
                  final author = await prefs.getString('username');
                  await FirebaseFirestore.instance.collection('posts').add({
                    'title': title,
                    'author': author,
                    'content': content,
                    'likes': 0,
                    'comments': []
                  });
                },
                child: Text('Post'))
          ],
        ),
      ),
    );
  }
}