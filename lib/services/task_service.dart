import 'dart:convert';

import 'package:minitask_app/models/task_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskService {
  static const String _taskKey = 'task_data';

  Future<void> saveTasks(List<TaskModel> tasks) async {
    // Chuyển Object sang List Map:
    List<Map<String, dynamic>> list = tasks
        .map((task) => task.toMap())
        .toList();
    //Biến List Map thành chuỗi JSON
    final jsonString = jsonEncode(list);
    //Ghi xuống ổ cứng
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_taskKey, jsonString);
  }

  Future<List<TaskModel>> getTasks() async {
    //Đọc chuỗi từ ổ cứng
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_taskKey);
    //Kiểm tra biên
    if (jsonString == null) {
      return [];
    }
    // Giải mã chuỗi JSON thành Danh sách Object
    final List<dynamic> rawList = jsonDecode(jsonString);
    return rawList.map((item) =>
        TaskModel.fromMap(item as Map<String, dynamic>)).toList();
  }
}