import 'package:flutter/material.dart';

class Comment {
  final String author;
  final String text;

  Comment({required this.author, required this.text});
}

class TaskComments extends StatefulWidget {
  @override
  _TaskCommentsState createState() => _TaskCommentsState();
}

class _TaskCommentsState extends State<TaskComments> {
  final List<Comment> _comments = [];

  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    String newCommentText = _commentController.text.trim();
    if (newCommentText.isNotEmpty) {
      Comment newComment = Comment(author: 'You', text: newCommentText);
      setState(() {
        _comments.add(newComment);
      });
      _commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _comments.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_comments[index].text),
                subtitle: Text(_comments[index].author),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Write your comment...',
                  ),
                ),
              ),
              SizedBox(width: 8.0),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
