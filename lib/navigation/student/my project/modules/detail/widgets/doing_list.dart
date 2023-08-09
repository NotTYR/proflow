import 'package:ProFlow/extensions.dart';
import 'package:ProFlow/navigation/student/my%20project/modules/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'add_task.dart';
import 'expanded_task.dart';

class DoingList extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  DoingList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => homeCtrl.doingTodos.isEmpty && homeCtrl.doneTodos.isEmpty
        ? Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 6.0.wp,
                  top: 30.0.wp,
                  bottom: 10.0.wp,
                ),
                child: Image.asset(
                  'assets/note.png',
                  fit: BoxFit.cover,
                  width: 40.0.wp,
                ),
              ),
              Text(
                'Add Task',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0.sp,
                ),
              ),
            ],
          )
        : ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: [
              ...homeCtrl.doingTodos
                  .map((element) => Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 3.0.wp,
                          horizontal: 9.0.wp,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Checkbox(
                                  fillColor: MaterialStateProperty.resolveWith(
                                      (states) => Colors.grey),
                                  value: element['done'],
                                  onChanged: (value) {
                                    homeCtrl.doneTodo(
                                        element['title'],
                                        element['assigned'],
                                        element['duedate']);
                                  }),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 4.0.wp,
                              ),
                              child: Container(
                                constraints: BoxConstraints(maxWidth: 50.0.wp),
                                child: Text(
                                  element['title'],
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                              child: TextButton(
                                onPressed: () {
                                  Get.to(
                                      () => ExpandedTask(
                                            TaskData: {
                                              'title': element['title'],
                                              'assigned': element['assigned'],
                                              'duedate': element['duedate']
                                            },
                                          ),
                                      transition: Transition.rightToLeft);
                                },
                                child: Text('View details'),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  alignment: Alignment.center,
                                ),
                              ),
                            )
                          ],
                        ),
                      ))
                  .toList(),
              if (homeCtrl.doingTodos.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
                  child: const Divider(
                    thickness: 2,
                  ),
                )
            ],
          ));
  }
}
