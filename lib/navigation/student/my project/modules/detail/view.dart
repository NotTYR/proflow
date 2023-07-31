import 'package:ProFlow/extensions.dart';
import 'package:ProFlow/navigation/student/homepage.dart';
import 'package:ProFlow/navigation/student/my%20project/modules/detail/widgets/add_task.dart';
import 'package:ProFlow/navigation/student/my%20project/modules/detail/widgets/doing_list.dart';
import 'package:ProFlow/navigation/student/my%20project/modules/detail/widgets/done_list.dart';
import 'package:ProFlow/navigation/student/my%20project/modules/home/controller.dart';
import 'package:ProFlow/navigation/student/my%20project/modules/home/widgets/add_card.dart';
import 'package:ProFlow/navigation/student/my%20project/modules/home/widgets/add_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class DetailPage extends StatefulWidget {
  final homeCtrl = Get.find<HomeController>();
  DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final homeCtrl = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    var task = homeCtrl.task.value!;
    var color = HexColor.fromHex(task.color);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Form(
          key: homeCtrl.formKey,
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(3.0.wp),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                        homeCtrl.updateTodos();
                        homeCtrl.changeTask(null);
                        homeCtrl.editCtrl.clear();
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.0.wp,
                ),
                child: Row(
                  children: [
                    Icon(
                      IconData(
                        task.icon,
                        fontFamily: 'MaterialIcons',
                      ),
                      color: color,
                    ),
                    SizedBox(
                      width: 3.0.wp,
                    ),
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 12.0.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() {
                var totalTodos =
                    homeCtrl.doingTodos.length + homeCtrl.doneTodos.length;
                return Padding(
                  padding: EdgeInsets.only(
                    left: 16.0.wp,
                    top: 3.0.wp,
                    right: 16.0.wp,
                  ),
                  child: Row(
                    children: [
                      Text(
                        '$totalTodos Tasks',
                        style: TextStyle(
                          fontSize: 12.0.sp,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        width: 3.0.wp,
                      ),
                      Expanded(
                        child: StepProgressIndicator(
                          totalSteps: totalTodos == 0 ? 1 : totalTodos,
                          currentStep: homeCtrl.doneTodos.length,
                          size: 5,
                          padding: 0,
                          selectedGradientColor: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [color.withOpacity(0.5), color],
                          ),
                          unselectedGradientColor: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.grey[300]!, Colors.grey[300]!],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              // Padding(
              //   padding: EdgeInsets.symmetric(
              //     vertical: 2.0.wp,
              //     horizontal: 5.0.wp,
              //   ),
              //   child: TextFormField(
              //     controller: homeCtrl.editCtrl,
              //     autofocus: true,
              //     decoration: InputDecoration(
              //       focusedBorder: UnderlineInputBorder(
              //         borderSide: BorderSide(color: Colors.grey[400]!),
              //       ),
              //       prefixIcon: Icon(
              //         Icons.check_box_outline_blank,
              //         color: Colors.grey[400]!,
              //       ),
              //       suffixIcon: IconButton(
              //         onPressed: () {
              //           if (homeCtrl.formKey.currentState!.validate()) {
              //             var success =
              //                 homeCtrl.addTodo(homeCtrl.editCtrl.text);
              //             if (success) {
              //               EasyLoading.showSuccess('Added');
              //             } else {
              //               EasyLoading.showError('Item already exists');
              //             }
              //             homeCtrl.editCtrl.clear();
              //           }
              //         },
              //         icon: const Icon(Icons.done),
              //       ),
              //     ),
              //     validator: (value) {
              //       if (value == null || value.trim().isEmpty) {
              //         return 'Please enter your todo item';
              //       }
              //       return null;
              //     },
              //   ),
              // ),
              // Padding(
              //   padding: EdgeInsets.symmetric(
              //     horizontal: 5.0.wp,
              //     vertical: 2.0.hp,
              //   ),
              //   child: Text(
              //     'Assign to:',
              //     style: TextStyle(fontSize: 11.0.sp),
              //   ),
              // ),

              // Padding(
              //   padding: EdgeInsets.symmetric(
              //     horizontal: 5.0.wp,
              //     vertical: 2.0.hp,
              //   ),
              //   child: Row(
              //     children: [
              //       SizedBox(
              //         width: 20,
              //         height: 20,
              //         child: Checkbox(
              //           fillColor: MaterialStateProperty.resolveWith(
              //               (states) => Colors.grey),
              //           value: isChecked,
              //           onChanged: (bool? value) {
              //             isChecked = false;
              //           },
              //         ),
              //       ),
              //       Padding(
              //         padding: EdgeInsets.symmetric(
              //           horizontal: 4.0.wp,
              //         ),
              //         child: Text(
              //           'Member name',
              //           overflow: TextOverflow.ellipsis,
              //         ),
              //       )
              //     ],
              //   ),
              // ),
              DoingList(),
              DoneList(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(() => AddTask(), transition: Transition.downToUp);
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}


// class DetailPage extends StatelessWidget {
//   final homeCtrl = Get.find<HomeController>();
//   DetailPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     var task = homeCtrl.task.value!;
//     var color = HexColor.fromHex(task.color);
//     return WillPopScope(
//       onWillPop: () async => false,
//       child: Scaffold(
//         body: Form(
//           key: homeCtrl.formKey,
//           child: ListView(
//             children: [
//               Padding(
//                 padding: EdgeInsets.all(3.0.wp),
//                 child: Row(
//                   children: [
//                     IconButton(
//                       onPressed: () {
//                         Get.back();
//                         homeCtrl.updateTodos();
//                         homeCtrl.changeTask(null);
//                         homeCtrl.editCtrl.clear();
//                       },
//                       icon: const Icon(Icons.arrow_back),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: 8.0.wp,
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(
//                       IconData(
//                         task.icon,
//                         fontFamily: 'MaterialIcons',
//                       ),
//                       color: color,
//                     ),
//                     SizedBox(
//                       width: 3.0.wp,
//                     ),
//                     Text(
//                       task.title,
//                       style: TextStyle(
//                         fontSize: 12.0.sp,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Obx(() {
//                 var totalTodos =
//                     homeCtrl.doingTodos.length + homeCtrl.doneTodos.length;
//                 return Padding(
//                   padding: EdgeInsets.only(
//                     left: 16.0.wp,
//                     top: 3.0.wp,
//                     right: 16.0.wp,
//                   ),
//                   child: Row(
//                     children: [
//                       Text(
//                         '$totalTodos Tasks',
//                         style: TextStyle(
//                           fontSize: 12.0.sp,
//                           color: Colors.grey,
//                         ),
//                       ),
//                       SizedBox(
//                         width: 3.0.wp,
//                       ),
//                       Expanded(
//                         child: StepProgressIndicator(
//                           totalSteps: totalTodos == 0 ? 1 : totalTodos,
//                           currentStep: homeCtrl.doneTodos.length,
//                           size: 5,
//                           padding: 0,
//                           selectedGradientColor: LinearGradient(
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                             colors: [color.withOpacity(0.5), color],
//                           ),
//                           unselectedGradientColor: LinearGradient(
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                             colors: [Colors.grey[300]!, Colors.grey[300]!],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               }),
//               // Padding(
//               //   padding: EdgeInsets.symmetric(
//               //     vertical: 2.0.wp,
//               //     horizontal: 5.0.wp,
//               //   ),
//               //   child: TextFormField(
//               //     controller: homeCtrl.editCtrl,
//               //     autofocus: true,
//               //     decoration: InputDecoration(
//               //       focusedBorder: UnderlineInputBorder(
//               //         borderSide: BorderSide(color: Colors.grey[400]!),
//               //       ),
//               //       prefixIcon: Icon(
//               //         Icons.check_box_outline_blank,
//               //         color: Colors.grey[400]!,
//               //       ),
//               //       suffixIcon: IconButton(
//               //         onPressed: () {
//               //           if (homeCtrl.formKey.currentState!.validate()) {
//               //             var success =
//               //                 homeCtrl.addTodo(homeCtrl.editCtrl.text);
//               //             if (success) {
//               //               EasyLoading.showSuccess('Added');
//               //             } else {
//               //               EasyLoading.showError('Item already exists');
//               //             }
//               //             homeCtrl.editCtrl.clear();
//               //           }
//               //         },
//               //         icon: const Icon(Icons.done),
//               //       ),
//               //     ),
//               //     validator: (value) {
//               //       if (value == null || value.trim().isEmpty) {
//               //         return 'Please enter your todo item';
//               //       }
//               //       return null;
//               //     },
//               //   ),
//               // ),
//               // Padding(
//               //   padding: EdgeInsets.symmetric(
//               //     horizontal: 5.0.wp,
//               //     vertical: 2.0.hp,
//               //   ),
//               //   child: Text(
//               //     'Assign to:',
//               //     style: TextStyle(fontSize: 11.0.sp),
//               //   ),
//               // ),

//               // Padding(
//               //   padding: EdgeInsets.symmetric(
//               //     horizontal: 5.0.wp,
//               //     vertical: 2.0.hp,
//               //   ),
//               //   child: Row(
//               //     children: [
//               //       SizedBox(
//               //         width: 20,
//               //         height: 20,
//               //         child: Checkbox(
//               //           fillColor: MaterialStateProperty.resolveWith(
//               //               (states) => Colors.grey),
//               //           value: isChecked,
//               //           onChanged: (bool? value) {
//               //             isChecked = false;
//               //           },
//               //         ),
//               //       ),
//               //       Padding(
//               //         padding: EdgeInsets.symmetric(
//               //           horizontal: 4.0.wp,
//               //         ),
//               //         child: Text(
//               //           'Member name',
//               //           overflow: TextOverflow.ellipsis,
//               //         ),
//               //       )
//               //     ],
//               //   ),
//               // ),
//               DoingList(),
//               DoneList(),
//             ],
//           ),
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             Get.to(() => AddTask(), transition: Transition.downToUp);
//           },
//           child: Icon(Icons.add),
//         ),
//       ),
//     );
//   }
// }
