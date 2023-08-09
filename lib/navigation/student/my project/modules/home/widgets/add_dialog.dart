import 'package:ProFlow/extensions.dart';
import 'package:ProFlow/navigation/student/my%20project/modules/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ProFlow/navigation/student/my project/data/providers/task/provider.dart';

List assignedmembers = [];

class AddDialog extends StatefulWidget {
  const AddDialog({super.key});

  @override
  State<AddDialog> createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {
  final homeCtrl = Get.find<HomeController>();

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2024),
    ).then((value) {
      setState(() {
        if (value != null) {
          _dateTime = value;
        }
        print(assignedmembers);
      });
    });
  }

  DateTime _dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                        homeCtrl.editCtrl.clear();
                        homeCtrl.changeTask(null);
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
                                assignedmembers,
                                _dateTime.day.toString() +
                                    '/' +
                                    _dateTime.month.toString() +
                                    '/' +
                                    _dateTime.year.toString(),
                                0);
                            if (success) {
                              EasyLoading.showSuccess('Added');
                              Get.back();
                              homeCtrl.changeTask(null);
                            } else {
                              EasyLoading.showError('Item already exists');
                            }
                            homeCtrl.editCtrl.clear();
                            assignedmembers = [];
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
                  'Add to',
                  style: TextStyle(
                    fontSize: 14.0.sp,
                    color: Colors.grey[400],
                  ),
                ),
              ),
              ...homeCtrl.tasks
                  .map((element) => Obx(
                        () => InkWell(
                          onTap: () => homeCtrl.changeTask(element),
                          child: Padding(
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
                                      IconData(
                                        element.icon,
                                        fontFamily: 'MaterialIcons',
                                      ),
                                      color: HexColor.fromHex(element.color),
                                    ),
                                    SizedBox(
                                      width: 3.0.wp,
                                    ),
                                    Text(
                                      element.title,
                                      style: TextStyle(
                                        fontSize: 12.0.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                if (homeCtrl.task.value == element)
                                  const Icon(
                                    Icons.check,
                                    color: Colors.blue,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ))
                  .toList(),
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
              FutureBuilder(
                  future: GetMembers(),
                  builder: (BuildContext context, AsyncSnapshot memberlist) {
                    if (memberlist.hasData) {
                      List members = memberlist.data;
                      if (assignedmembers.length == 0) {
                        for (dynamic i in members) {
                          assignedmembers.add(false);
                        }
                      }
                      print(assignedmembers);
                      return Container(
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: List.generate(
                              members.length,
                              (index) => Column(
                                    children: [
                                      GroupMember(
                                          Name: members[index], Index: index)
                                    ],
                                  )),
                        ),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 2.0.hp,
                  horizontal: 5.0.wp,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
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
                            // SizedBox(
                            //   width: 4.0.wp,
                            // ),
                            // Text(
                            //   'Date',
                            //   style: TextStyle(
                            //     fontSize: 12.0.sp,
                            //   ),
                            // ),
                            SizedBox(
                              width: 4.0.wp,
                            ),
                            Text(
                              (_dateTime.day.toString() +
                                  '/' +
                                  _dateTime.month.toString() +
                                  '/' +
                                  _dateTime.year.toString()),
                              style: TextStyle(
                                fontSize: 14.0.sp,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              width: 4.0.wp,
                            ),
                            // REFER TO THIS FOR DATE PICKER: https://www.youtube.com/watch?v=JK3zztXnDxs
                            // includes how to use the values selected from the calendar - not done yet
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _showDatePicker();
                          },
                          child: Text(
                            'Select Date',
                            style: TextStyle(
                              fontSize: 10.0.sp,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white70,
                            foregroundColor: Colors.black,
                            elevation: 0,
                            side: BorderSide(
                              width: 0.5,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CheckBox extends StatefulWidget {
  final index;
  const CheckBox({super.key, required this.index});

  @override
  State<CheckBox> createState() => _CheckBoxState(index);
}

class _CheckBoxState extends State<CheckBox> {
  final index;
  _CheckBoxState(this.index);
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
          assignedmembers[index] = value!;
          isChecked = value!;
        });
      },
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

class GroupMember extends StatefulWidget {
  final String Name;
  final Index;
  const GroupMember({super.key, required this.Name, required this.Index});

  @override
  State<GroupMember> createState() => _GroupMemberState(this.Name, this.Index);
}

class _GroupMemberState extends State<GroupMember> {
  final Name;
  final Index;
  _GroupMemberState(this.Name, this.Index);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 3.0.wp,
        left: 5.0.wp,
        right: 5.0.wp,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CheckBox(
                index: Index,
              ),
              SizedBox(
                width: 1.0.wp,
              ),
              Text(
                Name,
                style: TextStyle(
                  fontSize: 12.0.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
