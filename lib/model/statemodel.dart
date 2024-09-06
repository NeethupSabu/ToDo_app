import 'dart:math';

import 'package:flutter/material.dart';
import 'package:todo_app/taskmodel/taskmodel.dart';

class TaskViewModel extends ChangeNotifier {
  List<Task> tasks = [];
  String? taskName;

  bool get isValid => taskName != null && dateCont.text == "" && timeCont == "";
  final dateCont = TextEditingController();
  final timeCont = TextEditingController();
  setTaskName(String value) {
    taskName = value;
    //log(value.toString());
    notifyListeners();
  }

  setDate(DateTime? date) {
    if (date == null) {
      return;
    }
    DateTime currentDate = DateTime.now();
    DateTime now =
        DateTime(currentDate.year, currentDate.month, currentDate.day);
    int diff = date.difference(now).inDays;
    if (diff == 0) {
      dateCont.text = "today";
    } else if (diff == 1) {
      dateCont.text = "Tommorrow";
    } else {
      dateCont.text = "${date.day}--${date.month}--${date.year}";
    }
    notifyListeners();
  }

  settime(TimeOfDay? time) {
    if (time == null) {
      return;
    }
    if (time.hour == 0) {
      timeCont.text = "12:${time.minute}AM";
    } else if (time.hour < 12) {
      timeCont.text = "${time.hour}:${time.minute} AM";
    } else if (time.hashCode == 12) {
      timeCont.text = "${time.hour}:${time.minute} PM";
    } else {
      timeCont.text = "${time.hour - 12}:${time.minute} PM";
    }
    notifyListeners();
  }

  addTask() {
    final task = Task(taskName!, dateCont.text, timeCont.text);
    tasks.add(task);
    timeCont.clear();
    dateCont.clear;
    notifyListeners();
  }
}
