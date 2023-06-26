import 'package:ProFlow/extensions.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:ProFlow/appbar.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../my project/core/values/colors.dart';
import '../my project/data/models/task.dart';
import '../my project/modules/home/controller.dart';
import '../my project/modules/widgets/icons.dart';
import 'retrieve_proposals.dart';

class ProposalPage extends StatefulWidget {
  ProposalPage({super.key});

  @override
  State<ProposalPage> createState() => _ProposalPageState();
}

//TODO: Change FutureBuilder to StreamBuilder so that it can continuously listen to changes
class _ProposalPageState extends State<ProposalPage> {
  @override
  Widget build(BuildContext context) {
    var squareWidth = Get.width - 12.0.wp;
    return Scaffold(
        appBar: AppBar(
          title: Text('Proposal Page'),
        ),
        body: Container(
          
          child: FutureBuilder(
              future: CheckForProjects(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data == 'true') {
                  return Center(
                    child: Text('Pending approval'),
                  );
                } else {
                  return Center(
                      child: ElevatedButton(
                          //link this to a page to input project details
                          onPressed: () {
                            Propose();
                          },
                          child: Text('Propose A Project')));
                }
              }),
        ));
  }

}
