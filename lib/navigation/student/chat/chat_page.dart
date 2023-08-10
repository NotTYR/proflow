import 'package:ProFlow/extensions.dart';
import 'package:ProFlow/navigation/student/create%20group/create_group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../home_page.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

Future<String> GetUsername() async {
  final prefs = await SharedPreferences.getInstance();
  String? username = await prefs.getString('username');
  if (username == null) {
    username = 'Error';
  }
  return username;
}

class _ChatState extends State<Chat> {
  List<Message> _messages = [];

  final TextEditingController _messageController = TextEditingController();

  ScrollController _scrollController = ScrollController();

  void _sendMessage(String text) async {
    final docuid = await GetDocUid();
    final currgrp =
        await FirebaseFirestore.instance.collection('groups').doc(docuid).get();
    print(currgrp);
    final prefs = await SharedPreferences.getInstance();
    String? username = await prefs.getString('username');
    if (username == null) {
      username = 'Error';
    }
    List currchat = currgrp.data()?['chat'];
    currchat.add({
      'sender': username,
      'text': text,
      'timestamp': DateTime.now().toString()
    });
    await FirebaseFirestore.instance
        .collection('groups')
        .doc(docuid)
        .update({'chat': currchat});
    _messageController.clear();

    // Scroll to the bottom after sending a message
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        leading: IconButton(
          onPressed: () {
            Get.to(() => HomePage(), transition: Transition.noTransition);
          },
          icon: Icon(Icons.home),
        ),
      ),
      body: FutureBuilder(
          future: GetUsername(),
          builder: (context, username) {
            return FutureBuilder(
                future: GetDocUid(),
                builder: (context, future) {
                  if (future.hasData) {
                    return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('groups')
                            .doc(future.data)
                            .snapshots(),
                        builder: (context, snapshot) {
                          final chat = snapshot.data?['chat'];
                          print(chat);
                          if (chat != null) {
                            _messages = [];
                            for (final msg in chat) {
                              _messages.add(Message(
                                  sender: msg['sender'],
                                  text: msg['text'],
                                  timestamp: msg['timestamp']));
                            }
                          }
                          return Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  padding: EdgeInsets.only(
                                    top: 2.0.hp,
                                    bottom: 3.0.hp,
                                  ),
                                  controller: _scrollController,
                                  itemCount: _messages.length,
                                  itemBuilder: (context, index) {
                                    return MessageBubble(
                                      self: username.data,
                                      message: _messages[index],
                                    );
                                  },
                                ),
                              ),
                              _buildMessageInput(),
                            ],
                          );
                        });
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                });
          }),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.only(
        left: 3.0.wp,
        right: 3.0.wp,
        top: 2.0.hp,
        bottom: 8.0.hp,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border(top: BorderSide(color: Colors.grey)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.0),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () async {
              String message = _messageController.text.trim();
              if (message.isNotEmpty) {
                _sendMessage(message);
              }
            },
          ),
        ],
      ),
    );
  }
}

class Message {
  final String sender;
  final String text;
  final String timestamp;

  Message({required this.sender, required this.text, required this.timestamp});
}

class MessageBubble extends StatelessWidget {
  final Message message;
  final self;

  MessageBubble({required this.message, required this.self});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          message.sender == self ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: message.sender == self ? Colors.blue[100] : Colors.grey[300],
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          crossAxisAlignment: message.sender == self
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              message.sender,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: message.sender == self
                    ? Colors.blue[800]
                    : Colors.grey[800],
              ),
            ),
            SizedBox(height: 4.0),
            Text(message.text),
            SizedBox(height: 8.0),
            Text(
              _formatTimestamp(message.timestamp),
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    String formattedDate = DateFormat('dd MMM y, h:mm a').format(dateTime);
    return formattedDate;
  }
}
