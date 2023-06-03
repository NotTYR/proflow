import 'package:flutter/material.dart';
import 'sheets_api.dart';
import 'package:http/http.dart' as http;

class IspMentorListRequest {
  static VisitIsp() async {
    dynamic getcookie = await http.get(Uri.https('isphs.hci.edu.sg'));
    dynamic rngcode = RegExp('z" value="(.*?)"').firstMatch(getcookie.body)![1];
    while (RegExp('.*[E].*').hasMatch(rngcode!)) {
      getcookie = await http.get(Uri.https('isphs.hci.edu.sg'));
      rngcode = RegExp('z" value="(.*?)"').firstMatch(getcookie.body)![1];
    }
    print(rngcode);
    final cookie = getcookie.headers["set-cookie"]?.split("; ")[0];
    if (cookie != null) {
      print(cookie);
      final code = 'code';
      final isp = await http.post(Uri.https('isphs.hci.edu.sg', 'pwd_auth.asp'),
          headers: {'Connection': 'close', 'Cookie': cookie},
          // TODO: crack the encrypted code
          body: code);
      final htmlstr = isp.body;
      print(htmlstr);
    }
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
