import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'sheets_api.dart';
import 'package:http/http.dart' as http;

class IspMentorListRequest {
  static final url = Uri.https('isphs.hci.edu.sg');
  static Future VisitIsp() async {
    final response = await http.get(url);
    print(response.body);
  }
}

class FindMentor extends StatelessWidget {
  const FindMentor({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () async {
                final user = {
                  UserFields.name: 'name',
                  UserFields.email: 'email',
                };
                await UserSheetsApi.insert([user]);
              },
              child: Text('add stuff to the sheets')),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }
}
