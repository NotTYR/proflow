import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

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
            Get.to(() => Post(), transition: Transition.noTransition);
          },
          icon: Icon(Icons.add),
        )
      ],
      automaticallyImplyLeading: true,
      leading: IconButton(
        onPressed: () {
          Get.to(() => HomePage(), transition: Transition.noTransition);
        },
        icon: const Icon(Icons.home),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
