import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'appbar.dart';
import 'msgcard.dart';

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
