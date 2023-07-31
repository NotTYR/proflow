import 'package:ProFlow/extensions.dart';
import 'package:ProFlow/navigation/student/my%20project/core/values/colors.dart';
import 'package:ProFlow/navigation/student/my%20project/data/models/task.dart';
import 'package:ProFlow/navigation/student/my%20project/modules/home/controller.dart';
import 'package:ProFlow/navigation/student/my%20project/modules/widgets/icons.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

class AddCard extends StatefulWidget {
  const AddCard({super.key});
  @override
  State<AddCard> createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  dynamic _icon;

  _openIconPicker() async {
    IconData? icon = await FlutterIconPicker.showIconPicker(context,
        iconPackModes: [IconPack.material]);
    _icon = icon;
    setState(() {});
  }

  final homeCtrl = Get.find<HomeController>();
  Color color = Colors.red;
  @override
  Widget build(BuildContext context) {
    final icons = getIcons();
    var squareWidth = Get.width - 12.0.wp;
    return Container(
        width: squareWidth / 2,
        height: squareWidth / 2,
        margin: EdgeInsets.all(3.0.wp),
        child: InkWell(
          onTap: () async {
            await Get.defaultDialog(
              titlePadding: EdgeInsets.symmetric(vertical: 5.0.wp),
              radius: 5,
              title: 'Task Type',
              content: Form(
                key: homeCtrl.formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.0.wp),
                      child: TextFormField(
                        controller: homeCtrl.editCtrl,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Title',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your task title';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0.wp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: _icon != null
                                  ? Icon(_icon)
                                  : Container(child: Icon(Icons.square))),
                          ElevatedButton(
                              onPressed: () {
                                _openIconPicker();
                              },
                              child: Text('Change Icon')),
                          ElevatedButton(
                              onPressed: () => pickColor(context),
                              child: Text('Change Colour'))
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        minimumSize: const Size(150, 40),
                      ),
                      onPressed: () {
                        if (homeCtrl.formKey.currentState!.validate()) {
                          int icon = _icon.codePoint;
                          String color = this.color.toHex();
                          var task = Task(
                              title: homeCtrl.editCtrl.text,
                              icon: icon,
                              color: color);
                          Get.back();
                          homeCtrl.addTask(task)
                              ? EasyLoading.showSuccess('Create success')
                              : EasyLoading.showError('Duplicated task');
                        }
                      },
                      child: const Text('Confirm'),
                    ),
                  ],
                ),
              ),
            );
            homeCtrl.editCtrl.clear();
            homeCtrl.changeChipIndex(
                0); //automatically clear the dialogue if u dismiss it
          },
          child: DottedBorder(
            color: Colors.grey[400]!,
            dashPattern: const [8, 4],
            child: Center(
              child: Icon(
                Icons.add,
                size: 10.0.wp,
                color: Colors.grey,
              ),
            ),
          ),
        ));
  }

  Widget buildColorPicker() => ColorPicker(
        pickerColor: color,
        onColorChanged: (color) => setState(() {
          this.color = color;
        }),
      );

  void pickColor(BuildContext context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Pick your colour'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildColorPicker(),
              TextButton(
                child: Text(
                  'Select',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      );
}
