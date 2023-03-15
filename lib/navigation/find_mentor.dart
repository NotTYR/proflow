import 'package:ProFlow/proposal_page.dart';
import 'package:flutter/material.dart';

class FindMentor extends StatelessWidget {
  const FindMentor({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: const Text('You have not proposed any projects.'),
              margin: const EdgeInsets.only(bottom: 15.0),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const ProposalPage();
                    },
                  ),
                );
              },
              child: const Text('Propose one now'),
            ),
          ],
        ),
      ),
    );
  }
}
