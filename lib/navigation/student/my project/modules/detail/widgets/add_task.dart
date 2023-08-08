import 'package:ProFlow/extensions.dart';
import 'package:ProFlow/navigation/student/create%20group/create_group.dart';
import 'package:ProFlow/navigation/student/my%20project/modules/home/controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:ProFlow/navigation/student/my project/modules/detail/view.dart';
import '../../../core/values/colors.dart';

class AddTask extends StatelessWidget {
  AddTask({super.key});

  @override
  Widget build(BuildContext context) {
    return willpopscope();
  }
}

class willpopscope extends StatefulWidget {
  const willpopscope({super.key});

  @override
  State<willpopscope> createState() => _willpopscopeState();
}

class _willpopscopeState extends State<willpopscope> {
  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2024),
    ).then((value) {
      setState(() {
        _dateTime = value!;
      });
    });
  }

  final homeCtrl = Get.find<HomeController>();
  DateTime _dateTime = DateTime.now();
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
                    icon: const Icon(Icons.close),
                  ),
                  TextButton(
                    style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent)),
                    onPressed: () {
                      if (homeCtrl.formKey.currentState!.validate()) {
                        var success = homeCtrl.addTodo(
                            homeCtrl.editCtrl.text,
                            [],
                            _dateTime.day.toString() +
                                '/' +
                                _dateTime.month.toString() +
                                '/' +
                                _dateTime.year.toString());
                        if (success) {
                          EasyLoading.showSuccess('Added');
                          Get.back();
                        } else {
                          EasyLoading.showError('Item already exists');
                        }
                        homeCtrl.editCtrl.clear();
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
            FutureBuilder(
                future: GetMembers(),
                builder: (BuildContext context, AsyncSnapshot memberlist) {
                  if (memberlist.hasData) {
                    print(memberlist.data);
                    List members = memberlist.data;
                    return Container(
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: List.generate(
                            members.length,
                            (index) => Column(
                                  children: [GroupMember(Name: members[index])],
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
                vertical: 3.0.wp,
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

class GroupMember extends StatefulWidget {
  final String Name;
  const GroupMember({super.key, required this.Name});

  @override
  State<GroupMember> createState() => _GroupMemberState(this.Name);
}

class _GroupMemberState extends State<GroupMember> {
  final Name;
  _GroupMemberState(this.Name);
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
              CheckBox(),
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
