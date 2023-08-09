import 'package:flutter/material.dart';
import 'package:ProFlow/guest_page.dart';

void main() {
  runApp(InvalidLogin());
}

class InvalidLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => GuestPage()));
            }
          },
          child: Icon(Icons.logout_outlined),
        ),
        body: Container(
          margin: new EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: Text("Please try again and log in with your HCI Email",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[600],
                )),
          ),
        ),
      ),
    );
  }
}
