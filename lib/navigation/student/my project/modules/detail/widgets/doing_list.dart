import 'package:ProFlow/extensions.dart';
import 'package:ProFlow/navigation/student/my%20project/modules/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
                                        element['duedate'],
                                        element['progress']);
                                  }),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 4.0.wp,
                              ),
                              child: Container(
                                width: 32.0.wp,
                                child: Text(
                                  element['title'],
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            SizedBox(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    element['progress'].toInt().toString() +
                                        '%',
                                    style: TextStyle(fontSize: 8.0.sp),
                                  ),
                                  Text(
                                    element['duedate'],
                                    style: TextStyle(
                                      fontSize: 8.0.sp,
                                      color:
                                          getColorForDate(element['duedate']),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 5.0.wp),
                            SizedBox(
                              height: 20,
                              child: TextButton(
                                onPressed: () {
                                  Get.to(
                                      () => ExpandedTask(
                                            TaskData: {
                                              'title': element['title'],
                                              'assigned': element['assigned'],
                                              'duedate': element['duedate'],
                                              'progress': element['progress'],
                                              'done': element['done']
                                            },
                                          ),
                                      transition: Transition.rightToLeft);
                                },
                                child: Text(
                                  'View details',
                                  style: TextStyle(fontSize: 9.0.sp),
                                ),
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

String formatDate(String dateStr) {
  // Split the date string into day, month, and year parts
  final dateParts = dateStr.split('/');

  // Map the month number to its abbreviation
  final monthMap = {
    '1': 'Jan',
    '2': 'Feb',
    '3': 'Mar',
    '4': 'Apr',
    '5': 'May',
    '6': 'Jun',
    '7': 'Jul',
    '8': 'Aug',
    '9': 'Sep',
    '10': 'Oct',
    '11': 'Nov',
    '12': 'Dec',
  };

  // Format the date as 'day Month'
  return '${dateParts[1]} ${monthMap[dateParts[0]]}';
}

Color getColorForDate(String dateStr) {
  final dateParts = dateStr.split('/');

  final dueDate = DateTime(
    int.parse(dateParts[2]), // year
    int.parse(dateParts[1]), // month
    int.parse(dateParts[0]), // day
  );

  final currentDate = DateTime.now();

  if (currentDate.isBefore(dueDate)) {
    return Colors.black; // Not reached, show black
  } else if (currentDate.year == dueDate.year &&
      currentDate.month == dueDate.month &&
      currentDate.day == dueDate.day) {
    return Colors.orange; // Same day, show yellow
  } else {
    return Colors.red; // Overdue, show red
  }
}
