import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ProFlow/navigation/student/my%20project/core/utils/keys.dart';
import 'package:ProFlow/navigation/student/my%20project/data/services/storage/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/task.dart';

class TaskProvider {
  final _storage = Get.find<StorageService>();

  Future<List<Task>> readTasks() async {
    var tasks = <Task>[];
    //jsonDecode(_storage.read(taskKey).toString())
    //    .forEach((e) => tasks.add(Task.fromJson(e)));
    final firestore = await FirebaseFirestore.instance;
    final doc = await GetDocUid();
    final document = await firestore.collection('groups').doc(doc).get();
    print('firestore data');
    print(document.data());
    print(document.data()?['task']);
    var taskdata = document.data()?['task'];
    for (var task in taskdata) {
      tasks.add(Task(
          color: task['color'],
          title: task['title'],
          icon: task['icon'],
          todos: task['todos']));
    }
    return tasks;
  }

  void writeTasks(List<Task> tasks) async {
    _storage.write(taskKey, jsonEncode(tasks));
    final firestore = await FirebaseFirestore.instance;
    final temptasks = [];
    for (final task in tasks) {
      temptasks.add({
        "title": task.title,
        "icon": task.icon,
        "color": task.color,
        "todos": task.todos
      });
    }
    final doc = await GetDocUid();
    final document = await firestore.collection('groups').doc(doc).get();
    await firestore.collection('groups').doc(doc).update({'task': temptasks});
  }
}

Future<String> GetDocUid() async {
  final prefs = await SharedPreferences.getInstance();
  final uid = await prefs.getString('uid');
  final firestore = FirebaseFirestore.instance;
  final groups = await firestore.collection('groups').get();
  for (var group in groups.docs) {
    if (group.data()['members'].contains(uid)) {
      return group.id;
    }
  }
  return 'placeholder';
}
