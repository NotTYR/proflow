import 'package:ProFlow/extensions.dart';
import 'package:ProFlow/navigation/student/my%20project/modules/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:ProFlow/navigation/student/my project/modules/detail/view.dart';
import '../../../core/values/colors.dart';
import 'comments.dart';

class ExpandedTask extends StatefulWidget {
  const ExpandedTask({super.key});

  @override
  State<ExpandedTask> createState() => _ExpandedTaskState();
}

class _ExpandedTaskState extends State<ExpandedTask> {
  final homeCtrl = Get.find<HomeController>();

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
                'Task Title',
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
                    child: Text(
                      'LIU YUAN HCI, TAN YOU REN HCI, YAP HAN YANG HCI, YE WENYANG HCI',
                      style: TextStyle(
                        fontSize: 12.0.sp,
                      ),
                      softWrap: true,
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
                        '29 Aug 2023',
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
              padding: EdgeInsets.symmetric(
                vertical: 3.0.wp,
                horizontal: 5.0.wp,
              ),
              child: Text(
                'Comments:',
                style: TextStyle(
                  fontSize: 14.0.sp,
                  color: Colors.grey[400],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 3.0.wp,
                horizontal: 5.0.wp,
              ),
              child: SizedBox(
                height: 50.0.hp,
                child: TaskComments(),
              ),
            )
          ],
        ),
      ),
    );
  }
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
