import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:minitask_app/models/task_enums.dart';
import 'package:minitask_app/models/task_model.dart';
import 'package:minitask_app/providers/task_provider.dart';
import 'package:provider/provider.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<StatefulWidget> createState() => CreateScreenState();
}

class CreateScreenState extends State<CreateScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descripController = TextEditingController();
  TaskPriority _selectedPriority = TaskPriority.low;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _descripController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Task")),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: FocusScope
            .of(context)
            .unfocus,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: ListView(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value
                        .trim()
                        .isEmpty) {
                      return "Title is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField(
                  items: TaskPriority.values
                      .map(
                        (priority) =>
                        DropdownMenuItem(
                          value: priority,
                          child: Text(priority.label),
                        ),
                  )
                      .toList(),
                  decoration: InputDecoration(labelText: "Priority"),
                  borderRadius: BorderRadius.circular(10),
                  onChanged: (value) =>
                      setState(() => _selectedPriority = value!),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descripController,
                  decoration: InputDecoration(
                    labelText: "Desciption",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      TaskModel task = TaskModel(id: "",
                          title: _titleController.text,
                          status: TaskStatus.pending,
                          priority: _selectedPriority,
                          description: _descripController.text,
                          createdAt: DateTime.now());
                      context.read<TaskProvider>().addTask(task);
                      context.pop();
                    }

                  },
                  child: const Text("Save Task"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
