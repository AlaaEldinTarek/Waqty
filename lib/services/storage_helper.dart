
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';

class StorageHelper {
  static const String _tasksKey = 'tasks';

  static Future<void> saveTasks(List<TaskModel> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final taskList = tasks.map((task) => task.toMap()).toList();
    prefs.setString(_tasksKey, jsonEncode(taskList));
  }

  static Future<List<TaskModel>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_tasksKey);
    if (data != null) {
      final List decoded = jsonDecode(data);
      return decoded.map((e) => TaskModel.fromMap(e)).toList();
    } else {
      return [];
    }
  }

  static Future<void> clearTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tasksKey);
  }
}
