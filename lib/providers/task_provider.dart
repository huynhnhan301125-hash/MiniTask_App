import 'package:flutter/material.dart';
import 'package:minitask_app/models/task_enums.dart';
import 'package:minitask_app/models/task_model.dart';
import 'package:minitask_app/services/task_service.dart';

class TaskProvider extends ChangeNotifier {
  List<TaskModel> _tasks = [];
  bool _isLoading = false;
  TaskStatus? _filterStatus;
  int _nextID = 1;

  List<TaskModel> get tasks => _tasks;
  final TaskService _service = TaskService();

  bool get isLoading => _isLoading;

  TaskStatus? get filterStatus => _filterStatus;

  // Hàm hiển thị danh sách task (theo bộ lọc nếu có)
  List<TaskModel> get displayTasks {
    if (_filterStatus == null) {
      return _tasks;
    } else {
      return _tasks.where((task) => task.status == _filterStatus).toList();
    }
  }

  // Hàm tải dữ liệu khi người dung mửo app
  Future<void> loadTasks() async {
    _isLoading = true;
    _tasks = await _service.getTasks();
    // Cập nhật biến đếm ID tiếp theo
    _nextID = _tasks.length + 1;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(TaskModel task) async {
    final newId = "T${_nextID.toString().padLeft(3, '0')}";

    final newTask = task.copyWith(id: newId);

    _nextID++;
    _tasks.insert(0, newTask);

    await _service.saveTasks(_tasks);
    notifyListeners();
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((task) => task.id == id);
    await _service.saveTasks(_tasks);
    notifyListeners();
  }

  Future<void> updateStatus(String id, TaskStatus newStatus) async {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      // Tạo ra bạn task mới nhờ vào method copywith() đã tạo ở task_model.dart
      final updateTask = _tasks[index].copyWith(status: newStatus);
      _tasks[index] = updateTask;
      await _service.saveTasks(_tasks);
      notifyListeners();
    }
  }

  void setFilter(TaskStatus? status) {
    _filterStatus = status;
    notifyListeners();
  }
}
