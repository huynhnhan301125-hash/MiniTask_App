import 'package:go_router/go_router.dart';
import 'package:minitask_app/models/task_model.dart';
import 'package:minitask_app/providers/task_provider.dart';
import 'package:minitask_app/screens/create_screen.dart';
import 'package:minitask_app/screens/detail_screen.dart';
import 'package:minitask_app/screens/home_screen.dart';
import 'package:provider/provider.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) =>
          ChangeNotifierProvider(create: (_) => TaskProvider(), child: child),
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/create',
          builder: (context, state) => const CreateScreen(),
        ),
        GoRoute(
          path: '/detail',
          builder: (context, state) {
            final task= state.extra as TaskModel;
            return DetailScreen(task:task);
          },
        ),
      ],
    ),
  ],
);
