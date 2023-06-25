import 'package:flutter/material.dart';
import 'package:ProFlow/appbar.dart';
import 'retrieve_proposals.dart';

class ProposalPage extends StatefulWidget {
  const ProposalPage({super.key});

  @override
  State<ProposalPage> createState() => _ProposalPageState();
}

//TODO: Change FutureBuilder to StreamBuilder so that it can continuously listen to changes
class _ProposalPageState extends State<ProposalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ProFlowAppBar(),
        body: FutureBuilder(
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
            }));
  }
}
