import 'package:ProFlow/navigation/student/create%20group/proposal_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../appbar.dart';
import 'sheets_api.dart';
import 'package:http/http.dart' as http;

dynamic path = rootBundle.loadString("assets/mdhash.js");

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
      final mdhash1 = await mdhash("Password6969", 7, 5, 271733878);
      print(mdhash1);
      final mdhash2 =
          await mdhash(rngcode + "221496r" + mdhash1, 7, 30 * 13, 439075796);
      print(mdhash2);
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

dynamic mdhash(i, Y, W, U) async {
  final jsfile = await path;
  i = i.evaluate("""${jsfile}MD5($i, $Y, $W, $U)""");
  return i;
}

class FindMentor extends StatelessWidget {
  const FindMentor({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProFlowAppBar(
        title: 'Find Mentor',
      ),
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
            child: Text('add stuff to the sheets'),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return ProposalPage();
                    },
                  ),
                );
              },
              child: Text('Propose a Project')),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }
}
