import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'guest_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';

class ProFlowAppBar extends StatelessWidget with PreferredSizeWidget {
  const ProFlowAppBar({super.key});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('ProFlow'),
      automaticallyImplyLeading: true,
      leading: IconButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: ((context) => HomePage())));
        },
        icon: const Icon(Icons.home),
      ),
      actions: [
        IconButton(
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
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
