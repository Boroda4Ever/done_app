import 'dart:collection';

import 'package:done/features/task_view_and_create/data/models/hive_task_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DataService extends ChangeNotifier {
  List<TaskModel> _notes = [];
  bool withoutDone = false;
  UnmodifiableListView<TaskModel> get notes => UnmodifiableListView(_notes);
  final String tasksHiveBox = 'tasks-box';
  Future<void> getItems() async {
    Box<TaskModel> box = await Hive.openBox<TaskModel>(tasksHiveBox);
    _notes = box.values.toList();
  }

  int doneCounter() {
    int temp = 0;
    for (var element in _notes) {
      if (element.done) {
        temp++;
      }
    }
    return temp;
  }

  void changeWithoutDone() {
    withoutDone = !withoutDone;
    notifyListeners();
  }

  Future<Box<TaskModel>> init() {
    getItems();
    return Hive.openBox<TaskModel>(tasksHiveBox);
  }

  Future<void> removeItemAtId(int id) async {
    Box<TaskModel> box = await Hive.openBox<TaskModel>(tasksHiveBox);
    final Map<dynamic, TaskModel> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.id == id) desiredKey = key;
    });
    await box.delete(desiredKey);
    _notes = box.values.toList();
    notifyListeners();
  }

  Future<void> removeItemAtKey({required int key}) async {
    Box<TaskModel> box = await Hive.openBox<TaskModel>(tasksHiveBox);
    await box.delete(key);
    _notes = box.values.toList();
    notifyListeners();
  }

  Future<void> addItem(TaskModel task) async {
    Box<TaskModel> box = await Hive.openBox<TaskModel>(tasksHiveBox);
    await box.add(task);
    _notes = box.values.toList();
    notifyListeners();
  }

  Future<void> changeCheck({required TaskModel task, required int key}) async {
    Box<TaskModel> box = await Hive.openBox<TaskModel>(tasksHiveBox);
    var text = box.getAt(key)!.text;
    var importance = box.getAt(key)!.importance;
    var deadline = box.getAt(key)!.deadline;
    var createdAt = box.getAt(key)!.createdAt;
    var updatedAt = box.getAt(key)!.updatedAt;
    var done = !box.getAt(key)!.done;

    await box.putAt(
        key,
        TaskModel(
            id: task.id,
            text: text,
            importance: importance,
            deadline: deadline,
            done: done,
            createdAt: createdAt,
            updatedAt: updatedAt));

    _notes = box.values.toList();
    notifyListeners();
  }
}
