import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:minitask_app/models/task_enums.dart';
import 'package:minitask_app/models/task_model.dart';
import 'package:minitask_app/providers/task_provider.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatefulWidget {
  final TaskModel task;

  const DetailScreen({super.key, required this.task});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late TaskStatus _selectStatus;

  @override
  void initState() {
    super.initState();
    _selectStatus = widget.task.status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Task Details")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("ID: ${widget.task.id}"),
              Divider(),
              Text("Title: ${widget.task.title}"),
              Divider(),
              Text("Description: ${widget.task.description}"),
              Divider(),
              Text(
                "Create at: ${DateFormat("dd/MM/yyyy HH:mm").format(
                    widget.task.createdAt)}",
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Priority: ${widget.task.priority.label}",
                    style: TextStyle(color: widget.task.priority.color,fontWeight: FontWeight.bold),),
                  DropdownButton(
                    value: _selectStatus,
                    items: TaskStatus.values
                        .map(
                          (status) =>
                          DropdownMenuItem(
                            value: status,
                            child: Text(status.label),
                          ),
                    )
                        .toList(),
                    onChanged: (TaskStatus? newStatus) {
                      if (newStatus != null) {
                        setState(() => _selectStatus = newStatus);
                      }
                    },
                  ),

                ],
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.read<TaskProvider>().deleteTask(widget.task.id);
                      context.pop();
                    },
                    child: Text("Delete Task"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TaskProvider>().updateStatus(
                        widget.task.id,
                        _selectStatus,
                      );
                      context.pop();
                    },
                    child: Text("Save"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
