import 'package:flutter/material.dart';
import 'sheets_api.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:xpath_selector/xpath_selector.dart';

class IspMentorListRequest {
  static VisitIsp() async {
    final getcookie =
        await http.get(Uri.https('isphs.hci.edu.sg', 'index.asp'));
    final cookie = getcookie.headers["set-cookie"]?.split("; ")[0];
    print(cookie);
    final isp = await http.post(Uri.https('isphs.hci.edu.sg', 'pwd_auth.asp'),
        headers: {'Connection': 'close'},
        body:
            'w=30&x=221496r&y=19d4b15c0ffdf482bca91e8fc71d8fc8&z=0.6820141&Remember=0&URL=%2Fprojectwork%2Fmentorlist.asp%3F&v=SENJUGFzc3dvcmQ2OTY5');
    final htmlstr = isp.body;
    print(htmlstr);
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
                IspMentorListRequest.VisitIsp();
              },
              child: Text('Isp request')),
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
