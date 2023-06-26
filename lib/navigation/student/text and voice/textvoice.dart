import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat',
      home: StreamBuilder(
        stream: _auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return ChatScreen();
            } else {
              return LoginScreen();
            }
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Sign In'),
          onPressed: () {
            _signIn(context);
          },
        ),
      ),
    );
  }

  void _signIn(BuildContext context) async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ChatScreen()),
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

class ChatScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _signOut(context);
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream:
            _firestore.collection('messages').orderBy('timestamp').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<DocumentSnapshot> messages = snapshot.data.docs;
            return ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> messageData = messages[index].data();
                String sender = messageData['sender'];
                String content = messageData['content'];
                DateTime timestamp = messageData['timestamp'].toDate();
                String formattedTime = '${timestamp.hour}:${timestamp.minute}';
                return ListTile(
                  title: Text(sender),
                  subtitle: Text(content),
                  trailing: Text(formattedTime),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _sendMessage();
        },
      ),
    );
  }

  void _signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  void _sendMessage() {
    String sender = _auth.currentUser.uid;
    String content = 'Hello, world!';
    DateTime timestamp = DateTime.now();

    _firestore.collection('messages').add({
      'sender': sender,
      'content': content,
      'timestamp': timestamp,
    });
  }
}
