
import 'package:flutter/material.dart';
enum TaskStatus{pending,inProgress,done}
enum TaskPriority{low,medium,high}

extension StatusExtension on TaskStatus{
  String get label{
    switch(this){
      case TaskStatus.pending: return "Pending";
      case TaskStatus.inProgress: return "In Progress";
      case TaskStatus.done: return "Done";
    }
  }
  bool get canDelete{
    return this==TaskStatus.done;
  }
}

extension TaskPriorityExtension on TaskPriority{
  String get label{
    switch(this){
      case TaskPriority.low: return "Low";
      case TaskPriority.medium: return "Medium";
      case TaskPriority.high: return "High";
    }
  }
  Color get color{
    switch(this){
      case TaskPriority.low: return Colors.yellow.shade700;
      case TaskPriority.medium: return Colors.orange.shade700;
      case TaskPriority.high: return Colors.red.shade700;
    }
  }
}