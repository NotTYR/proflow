import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:flutter_js/quickjs/ffi.dart';
import 'sheets_api.dart';
import 'package:http/http.dart' as http;

class IspMentorListRequest {
  static VisitIsp() async {
    final JavascriptRuntime jsRuntime = getJavascriptRuntime();
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
      final mdhash1 =
          await mdhash(jsRuntime, "HCIPassword6969", 7, 5, 271733878);
      print('mdhash1');
      print(mdhash1);
      final mdhash2 = await mdhash(jsRuntime, rngcode + "221496r" + mdhash1,
          "221496r".length, 30 * 13, 439075796);
      print('mdhash2');
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

Future<String> mdhash(JavascriptRuntime jsRuntime, i, Y, W, U) async {
  String md5 = await rootBundle.loadString('assets/mdhash.js');
  final result = jsRuntime.evaluate(md5 + """MD5($i, $Y, $W, $U)""");
  return result.stringResult.toString();
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
