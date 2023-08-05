import 'package:ProFlow/extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// class Chat extends StatefulWidget {
//   @override
//   _ChatState createState() => _ChatState();
// }

// class _ChatState extends State<Chat> {
//   final List<Message> _messages = [
//     Message(sender: 'YE WENYANG HCI', text: 'hi'),
//     Message(sender: 'LIU YUAN HCI', text: 'Hi!'),
//     Message(sender: 'TAN YOU REN HCI', text: 'hello'),
//   ];

//   final TextEditingController _messageController = TextEditingController();

//   void _sendMessage(String text) {
//     setState(() {
//       _messages.add(Message(sender: 'You', text: text));
//       _messageController.clear();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chat'),
//       ),
//       body: Column(
//         children: [
//           SizedBox(
//             height: 2.0.hp,
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 return MessageBubble(
//                   message: _messages[index],
//                 );
//               },
//             ),
//           ),
//           _buildMessageInput(),
//           SizedBox(
//             height: 6.0.hp,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMessageInput() {
//     return Container(
//       padding: const EdgeInsets.all(8.0),
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         border: Border(top: BorderSide(color: Colors.grey)),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _messageController,
//               decoration: InputDecoration(
//                 hintText: 'Type your message...',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(20.0),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(width: 8.0),
//           IconButton(
//             icon: Icon(Icons.send),
//             onPressed: () {
//               String message = _messageController.text.trim();
//               if (message.isNotEmpty) {
//                 _sendMessage(message);
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// class Message {
//   final String sender;
//   final String text;

//   Message({required this.sender, required this.text});
// }

// class MessageBubble extends StatelessWidget {
//   final Message message;

//   MessageBubble({required this.message});

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: message.sender == 'You'
//           ? Alignment.centerRight
//           : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
//         padding: const EdgeInsets.all(12.0),
//         decoration: BoxDecoration(
//           color: message.sender == 'You' ? Colors.blue[100] : Colors.grey[300],
//           borderRadius: BorderRadius.circular(16.0),
//         ),
//         child: Column(
//           crossAxisAlignment: message.sender == 'You'
//               ? CrossAxisAlignment.end
//               : CrossAxisAlignment.start,
//           children: [
//             Text(
//               message.sender,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: message.sender == 'You'
//                     ? Colors.blue[800]
//                     : Colors.grey[800],
//               ),
//             ),
//             SizedBox(height: 4.0),
//             Text(message.text),
//           ],
//         ),
//       ),
//     );
//   }
// }

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final List<Message> _messages = [
    Message(
      sender: 'YE WENYANG HCI',
      text: 'hi',
      timestamp: DateTime.now().subtract(Duration(minutes: 30)),
    ),
    Message(
      sender: 'LIU YUAN HCI',
      text: 'Hi!',
      timestamp: DateTime.now().subtract(Duration(minutes: 25)),
    ),
    Message(
      sender: 'TAN YOU REN HCI',
      text: 'hello',
      timestamp: DateTime.now().subtract(Duration(minutes: 22)),
    ),
  ];

  final TextEditingController _messageController = TextEditingController();

  void _sendMessage(String text) {
    setState(() {
      _messages
          .add(Message(sender: 'You', text: text, timestamp: DateTime.now()));
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 2.0.hp,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return MessageBubble(
                  message: _messages[index],
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
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
            onPressed: () {
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
  final DateTime timestamp;

  Message({required this.sender, required this.text, required this.timestamp});
}

class MessageBubble extends StatelessWidget {
  final Message message;

  MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.sender == 'You'
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: message.sender == 'You' ? Colors.blue[100] : Colors.grey[300],
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          crossAxisAlignment: message.sender == 'You'
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              message.sender,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: message.sender == 'You'
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

  String _formatTimestamp(DateTime timestamp) {
    String formattedTime = DateFormat.Hm().format(timestamp);
    return formattedTime;
  }
}
