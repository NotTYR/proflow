import 'package:ProFlow/extensions.dart';
import 'package:flutter/material.dart';
import 'package:ProFlow/guest_page.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

void main() {
  runApp(InvalidLogin());
}

class InvalidLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Invalid Email'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
                'Sorry, ProFlow is only available for students in Hwa Chong Institution'),
            SizedBox(height: 1.0.hp),
            Text(
                'If you are a student here, please try again with your HCI email address (@student.hci.edu.sg)'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Back to Login'),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => GuestPage()));
          },
        ),
      ],
    );
  }
}
