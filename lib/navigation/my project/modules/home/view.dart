import 'package:ProFlow/navigation/my%20project/core/values/colors.dart';
import 'package:ProFlow/navigation/my%20project/data/models/task.dart';
import 'package:ProFlow/navigation/my%20project/modules/home/controller.dart';
import 'package:ProFlow/navigation/my%20project/modules/home/widgets/add_card.dart';
import 'package:ProFlow/navigation/my%20project/modules/home/widgets/add_dialog.dart';
import 'package:ProFlow/navigation/my%20project/modules/home/widgets/task_card.dart';
import 'package:ProFlow/navigation/my%20project/modules/report/view.dart';
import 'package:ProFlow/navigation/my%20project/tasks.dart';
import 'package:flutter/material.dart';
import 'package:ProFlow/appbar.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:ProFlow/navigation/my project/core/utils/extensions.dart';
import 'package:get_storage/get_storage.dart';

// this is the home screen for the task list

class MyProjects extends GetView<HomeController> {
  const MyProjects({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProFlowAppBar(),
      body: Obx(
        () => IndexedStack(
          index: controller.tabIndex.value,
          children: [
            SafeArea(
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 3.0.wp,
                      top: 8.0.wp,
                      bottom: 4.0.wp,
                    ),
                    child: Text(
                      'My Tasks',
                      style: TextStyle(
                        fontSize: 20.0.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Obx(
                    () => GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      children: [
                        ...controller.tasks
                            .map((element) => LongPressDraggable(
                                data: element,
                                onDragStarted: () =>
                                    controller.changeDeleting(true),
                                onDraggableCanceled: (_, __) =>
                                    controller.changeDeleting(false),
                                onDragEnd: (_) =>
                                    controller.changeDeleting(false),
                                feedback: Opacity(
                                  opacity: 0.8,
                                  child: TaskCard(task: element),
                                ),
                                child: TaskCard(task: element)))
                            .toList(),
                        AddCard()
                      ],
                    ),
                  )
                ],
              ),
            ),
            ReportPage(),
          ],
        ),
      ),
      floatingActionButton: DragTarget<Task>(
        builder: (_, __, ___) {
          return Obx(
            () => FloatingActionButton(
              backgroundColor: controller.deleting.value ? Colors.red : blue,
              onPressed: () {
                if (controller.tasks.isNotEmpty) {
                  Get.to(() => AddDialog(), transition: Transition.downToUp);
                } else {
                  EasyLoading.showInfo('Please create a task group first');
                }
              },

              child: Icon(controller.deleting.value
                  ? Icons.delete
                  : Icons.add), //switches from add to delete
            ),
          );
        },
        onAccept: (Task task) {
          controller.deleteTask(task);
          EasyLoading.showSuccess('Deleted');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: Obx(
          () => BottomNavigationBar(
            onTap: (int index) => controller.changeTabIndex(index),
            currentIndex: controller.tabIndex.value,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                label: 'Dashboard',
                icon: Padding(
                  padding: EdgeInsets.only(right: 13.0.wp),
                  child: const Icon(Icons.dashboard),
                ),
              ),
              BottomNavigationBarItem(
                label: 'Report',
                icon: Padding(
                  padding: EdgeInsets.only(left: 13.0.wp),
                  child: const Icon(Icons.data_usage),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
