import 'package:ProFlow/extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'forum.dart';

class ExpandedPost extends StatefulWidget {
  const ExpandedPost({super.key});

  @override
  State<ExpandedPost> createState() => _ExpandedPostState();
}

class _ExpandedPostState extends State<ExpandedPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Scaffold(),
    );
  }
}
