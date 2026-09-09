import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:minitask_app/models/task_enums.dart';
import 'package:minitask_app/models/task_model.dart';
import 'package:minitask_app/providers/task_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  // Nạp dữ liệu ban đầu
  @override
  void initState() {
    super.initState();
    // addPostFrameCallback: Sau khi frame đầu tiên vẽ xong, hãy chạy đoạn code này
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Lắng nghe provider
    final provider = context.watch<TaskProvider>();
    bool isLoading = provider.isLoading;
    List<TaskModel> tasks = provider.displayTasks;
    TaskStatus? taskStatus = provider.filterStatus;
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: isLoading == true
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4, // Khoảng cách xuống dòng
                    children: [
                      FilterChip(
                        label: Text("All"),
                        onSelected: (_) =>
                            context.read<TaskProvider>().setFilter(null),
                        selected: taskStatus == null,
                      ),
                      FilterChip(
                        label: Text("Pending"),
                        onSelected: (_) => context
                            .read<TaskProvider>()
                            .setFilter(TaskStatus.pending),
                        selected: taskStatus == TaskStatus.pending,
                      ),
                      FilterChip(
                        label: Text("In Progress"),
                        onSelected: (_) => context
                            .read<TaskProvider>()
                            .setFilter(TaskStatus.inProgress),
                        selected: taskStatus == TaskStatus.inProgress,
                      ),
                      FilterChip(
                        label: Text("Done"),
                        onSelected: (_) => context
                            .read<TaskProvider>()
                            .setFilter(TaskStatus.done),
                        selected: taskStatus == TaskStatus.done,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  // ListView.builder tải dự liệu theo ky thuật  Lazy Loading
                  child: ListView.builder(
                    itemBuilder: (context, index) => ListTile(
                      title: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: [
                            TextSpan(
                              text: '[${tasks[index].id}]',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            WidgetSpan(child: SizedBox(width: 20,)),
                            TextSpan(text: tasks[index].title),
                          ],
                        ),
                      ),
                      subtitle: Text(tasks[index].status.label),
                      leading: CircleAvatar(
                        backgroundColor: tasks[index].priority.color,
                        radius: 8,
                      ),
                      trailing: Text(
                        "${tasks[index].createdAt.day}/${tasks[index].createdAt.month}/${tasks[index].createdAt.year}",
                      ),
                      onTap: () => context.push('/detail', extra: tasks[index]),
                    ),
                    itemCount: tasks.length,
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/create'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
