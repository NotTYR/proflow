import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import '../../../appbar.dart';

class TextChannel extends StatefulWidget {
  @override
  _TextChannelState createState() => _TextChannelState();
}

class Message {
  final String text;
  final DateTime date;
  final bool isSentByMe;

  const Message({
    required this.text,
    required this.date,
    required this.isSentByMe,
  });
}

class _TextChannelState extends State<TextChannel> {
  TextEditingController _textController = TextEditingController();
  CollectionReference _messagesCollection =
      FirebaseFirestore.instance.collection('messages');
  List<Message> messages = [
    Message(
      text: 'Your Message...',
      date: DateTime.now(),
      isSentByMe: false,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProFlowAppBar(),
      body: Column(children: [
        Expanded(
          child: Container(
            child: GroupedListView<Message, DateTime>(
              padding: const EdgeInsets.all(8),
              reverse: true,
              order: GroupedListOrder.DESC,
              useStickyGroupSeparators: true,
              floatingHeader: true,
              elements: messages,
              groupBy: (message) => DateTime(
                message.date.year,
                message.date.month,
                message.date.day,
              ),
              groupHeaderBuilder: (Message message) => SizedBox(
                height: 40,
                child: Center(
                  child: Card(
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        DateFormat.yMMMd().format(message.date),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              itemBuilder: (context, Message message) => Align(
                alignment: message.isSentByMe
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Card(
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(message.text),
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          color: Colors.grey.shade200,
          child: TextField(
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(12),
              hintText: 'Your message...',
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
      ]),
    );
  }
}
