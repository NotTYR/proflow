import 'package:flutter/material.dart';
import 'home_page.dart';

class ProFlowAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const ProFlowAppBar({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      automaticallyImplyLeading: true,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(
              context, MaterialPageRoute(builder: ((context) => HomePage())));
        },
        icon: const Icon(Icons.home),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
