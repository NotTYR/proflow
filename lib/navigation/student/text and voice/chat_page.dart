import 'package:ProFlow/navigation/student/text%20and%20voice/messages_widget.dart';
import 'package:ProFlow/navigation/student/text%20and%20voice/new_message_widget.dart';
import 'package:flutter/material.dart';
import 'user.dart';

class ChatPage extends StatefulWidget {
  final user;
  const ChatPage({
    required this.user,
    required Key key,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.blue,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: MessagesWidget(
                    idUser: widget.user.idUser,
                    key: UniqueKey(),
                  ),
                ),
              ),
              NewMessageWidget(
                idUser: widget.user.idUser,
                key: UniqueKey(),
              )
            ],
          ),
        ),
      );
}
