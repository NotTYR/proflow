import 'package:flutter/material.dart';

import '../../../home_page.dart';
import 'new_post.dart';

class ForumAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ForumAppBar({super.key});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Forum'),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Post()));
          },
          icon: Icon(Icons.add),
        )
      ],
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
