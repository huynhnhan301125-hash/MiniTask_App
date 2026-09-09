import 'package:minitask_app/models/task_enums.dart';

class TaskModel {
  final String id;
  final String title;
  final String? description;
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime createdAt;
  final DateTime? reminderAt;

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    required this.priority,
    required this.createdAt,
    this.reminderAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'title': this.title,
      'description': this.description,
      'status': this.status.name,
      'priority': this.priority.name,
      'createdAt': this.createdAt.toIso8601String(),
      'reminderAt':this.reminderAt?.toIso8601String(),
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      // ?? "..."
      status: TaskStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => TaskStatus.pending,
      ),
      priority: TaskPriority.values.firstWhere(
        (e) => e.name == map['priority'],
        orElse: () => TaskPriority.low,
      ),
      createdAt: DateTime.parse(map['createdAt']),
      reminderAt: map['reminderAt'] != null
          ? DateTime.parse(map['reminderAt'])
          : null,
    );
  }

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    TaskStatus? status,
    TaskPriority? priority,
    DateTime? createdAt,
    DateTime? reminderAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      reminderAt: reminderAt ?? this.reminderAt,
    );
  }
}
