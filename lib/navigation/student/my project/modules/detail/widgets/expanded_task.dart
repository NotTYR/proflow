import 'package:ProFlow/extensions.dart';
import 'package:ProFlow/navigation/student/my%20project/modules/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:ProFlow/navigation/student/my project/modules/detail/view.dart';
import '../../../core/values/colors.dart';
import 'comments.dart';
import 'package:ProFlow/navigation/student/my project/data/providers/task/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExpandedTask extends StatefulWidget {
  final TaskData;
  const ExpandedTask({super.key, required this.TaskData});

  @override
  State<ExpandedTask> createState() => _ExpandedTaskState(TaskData);
}

class _ExpandedTaskState extends State<ExpandedTask> {
  final TaskData;
  final homeCtrl = Get.find<HomeController>();
  _ExpandedTaskState(this.TaskData);

  late int _currentSliderValue = TaskData['progress'].toInt();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(3.0.wp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
              child: Text(
                TaskData['title'],
                style: TextStyle(
                  fontSize: 18.0.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 5.0.wp,
                left: 5.0.wp,
                right: 5.0.wp,
                bottom: 2.0.wp,
              ),
              child: Row(
                children: [
                  Text(
                    'Assigned To:',
                    style: TextStyle(
                      fontSize: 14.0.sp,
                      color: Colors.grey[400],
                    ),
                  ),
                  SizedBox(
                    width: 3.0.wp,
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: GetMembers(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          String assigned = '';
                          int i = 0;
                          for (final assign in TaskData['assigned']) {
                            if (assign == true) {
                              if (assigned != '') {
                                assigned =
                                    (assigned + ",\n" + snapshot.data?[i]);
                              } else {
                                assigned = (snapshot.data?[i]);
                              }
                            }
                            i++;
                          }
                          return Text(
                            assigned,
                            style: TextStyle(
                              fontSize: 12.0.sp,
                            ),
                            softWrap: true,
                          );
                        } else {
                          return Text('');
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 3.0.wp,
                horizontal: 5.0.wp,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Due:',
                        style: TextStyle(
                          fontSize: 14.0.sp,
                          color: Colors.grey[400],
                        ),
                      ),
                      SizedBox(
                        width: 4.0.wp,
                      ),
                      Text(
                        TaskData['duedate'],
                        style: TextStyle(
                          fontSize: 12.0.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 5.0.wp,
                left: 5.0.wp,
                right: 5.0.wp,
                bottom: 2.0.wp,
              ),
              child: Text(
                'Progress:',
                style: TextStyle(
                  fontSize: 14.0.sp,
                  color: Colors.grey[400],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 1.0.hp,
                left: 0.5.wp,
                right: 0.5.wp,
              ),
              child: Slider(
                value: _currentSliderValue.toDouble(),
                max: 100,
                divisions: 100,
                label: _currentSliderValue.round().toString() + '%',
                onChanged: (value) {
                  setState(() {
                    if (value == 100) {
                      homeCtrl.doneTodo(TaskData['title'], TaskData['assigned'],
                          TaskData['duedate'], 100);
                    } else {
                      print('update');
                      homeCtrl.updateTodoProgress(
                          TaskData['title'],
                          TaskData['assigned'],
                          TaskData['duedate'],
                          _currentSliderValue,
                          value.round());
                    }
                    _currentSliderValue = value.round();
                  });
                },
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.symmetric(
            //     vertical: 3.0.wp,
            //     horizontal: 5.0.wp,
            //   ),
            //   child: Text(
            //     'Comments:',
            //     style: TextStyle(
            //       fontSize: 14.0.sp,
            //       color: Colors.grey[400],
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: EdgeInsets.symmetric(
            //     vertical: 3.0.wp,
            //     horizontal: 5.0.wp,
            //   ),
            //   child: SizedBox(
            //     height: 50.0.hp,
            //     child: TaskComments(),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}

Future<List> GetMembers() async {
  final docuid = await GetDocUid();
  final identity =
      await FirebaseFirestore.instance.collection('identity').get();
  final group =
      await FirebaseFirestore.instance.collection('groups').doc(docuid).get();
  final memberuid = group['members'];
  List members = [];
  List identities = [];
  for (final data in identity.docs) {
    identities.add([data['username'], data['uid']]);
  }
  for (final member in memberuid) {
    for (final data in identities) {
      if (data[1] == member) {
        members.add(data[0]);
      }
    }
  }
  print(members);
  return members;
}

class CheckBox extends StatefulWidget {
  const CheckBox({super.key});

  @override
  State<CheckBox> createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      return Colors.grey;
    }

    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
        });
      },
    );
  }
}
