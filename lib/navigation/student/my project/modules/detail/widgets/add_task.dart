import 'package:ProFlow/extensions.dart';
import 'package:ProFlow/navigation/student/my%20project/modules/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:ProFlow/navigation/student/my project/modules/detail/view.dart';
import '../../../core/values/colors.dart';

class AddTask extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  AddTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  icon: const Icon(Icons.close),
                ),
                TextButton(
                  style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent)),
                  onPressed: () {
                    if (homeCtrl.formKey.currentState!.validate()) {
                      if (homeCtrl.task.value == null) {
                        EasyLoading.showError('Please select task type');
                      } else {
                        var success = homeCtrl.updateTask(
                          homeCtrl.task.value!,
                          homeCtrl.editCtrl.text,
                        );
                        if (success) {
                          EasyLoading.showSuccess('Added');
                          Get.back();
                          homeCtrl.changeTask(null);
                        } else {
                          EasyLoading.showError('Item already exists');
                        }
                        homeCtrl.editCtrl.clear();
                      }
                    }
                  },
                  child: Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 14.0.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
            child: Text(
              'New Task',
              style: TextStyle(
                fontSize: 20.0.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
            child: TextFormField(
              controller: homeCtrl.editCtrl,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey[400]!,
                  ),
                ),
              ),
              autofocus: true,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter an item';
                }
                return null;
              },
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
              'Assign To',
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.check_box_outline_blank,
                    ),
                    SizedBox(
                      width: 3.0.wp,
                    ),
                    Text(
                      'Member Name',
                      style: TextStyle(
                        fontSize: 12.0.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
