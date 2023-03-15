import 'package:ProFlow/navigation/find_mentor.dart';
import 'package:ProFlow/navigation/forum.dart';
import 'package:ProFlow/navigation/my_projects.dart';
import 'package:ProFlow/proposal_page.dart';
import 'package:ProFlow/save_login_data.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'guest_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  List<Widget> pages = const [
    FindMentor(),
    MyProjects(),
    ForumExp(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ProFlow'),
        automaticallyImplyLeading: true,
        leading: IconButton(
          onPressed: () async {
            try {
              await FirebaseAuth.instance.signOut();
              await GoogleSignIn().signOut();
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => GuestPage())));
            } catch (e) {
              print(e.toString());
            }
          },
          icon: const Icon(Icons.logout_outlined),
        ),
      ),
      body: pages[currentPage],
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.search_outlined), label: 'Find a Mentor'),
          NavigationDestination(
              icon: Icon(Icons.list_alt_rounded), label: 'My Projects'),
          NavigationDestination(
              icon: Icon(Icons.chat_outlined), label: 'Forum'),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        selectedIndex: currentPage,
      ),
    );
  }
}
