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
        body: Container(
          child: Text(forumdata['content']),
        ),
      ),
    );
  }
}
