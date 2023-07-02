import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:grouped_list/grouped_list.dart';
import '../../../appbar.dart';

class TextChannel extends StatefulWidget {
  @override
  _TextChannelState createState() => _TextChannelState();
}

class _TextChannelState extends State<TextChannel> {
  TextEditingController _textController = TextEditingController();
  CollectionReference _messagesCollection =
      FirebaseFirestore.instance.collection('messages');
  List<Message> messages = [
    Message(
      text: 'Message something cool!',
      date: DateTime.now(),
      isSentByMe: false,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProFlowAppBar(),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messagesCollection.orderBy('timestamp').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final messages = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message =
                        messages[index].data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(message['text']),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Enter message...',
                    ),
                    onSubmitted: (text) {
                      final message = Message(
                        text: text,
                        date: DateTime.now(),
                        isSentByMe: true,
                      );

                      setState(() => messages.add(message));
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    String text = _textController.text.trim();
    if (text.isNotEmpty) {
      _messagesCollection.add({
        'text': text,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
      _textController.clear();
    }
  }
}

class Message {
  final String text;
  final DateTime date;
  final bool isSentByMe;

  const Message(
      {required this.text, required this.date, required this.isSentByMe});
}
