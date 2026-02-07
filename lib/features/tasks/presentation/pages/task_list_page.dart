import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_system/config/injection_container.dart';
import 'package:hr_system/features/tasks/domain/entities/task.dart';
import 'package:hr_system/features/tasks/presentation/cubit/task_cubit.dart';
import 'package:hr_system/features/tasks/presentation/cubit/task_state.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<TaskCubit>()..loadTasks(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Tasks')),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.push('/tasks/add'),
          child: const Icon(Icons.add),
        ),
        body: BlocBuilder<TaskCubit, TaskState>(
          builder: (context, state) {
            if (state is TaskLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TaskLoaded) {
              if (state.tasks.isEmpty) {
                return const Center(child: Text('No tasks found'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.tasks.length,
                itemBuilder: (context, index) {
                  final task = state.tasks[index];
                  return Card(
                    child: ListTile(
                      title: Text(
                        task.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(task.description),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.person,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                task.assigneeName,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: _buildStatusChip(context, task),
                      isThreeLine: true,
                    ),
                  );
                },
              );
            } else if (state is TaskError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, Task task) {
    Color color;
    switch (task.status) {
      case TaskStatus.todo:
        color = Colors.orange;
        break;
      case TaskStatus.inProgress:
        color = Colors.blue;
        break;
      case TaskStatus.done:
        color = Colors.green;
        break;
    }

    return PopupMenuButton<TaskStatus>(
      initialValue: task.status,
      onSelected: (TaskStatus status) {
        context.read<TaskCubit>().updateStatus(task.id, status);
      },
      child: Chip(
        label: Text(
          task.status.toString().split('.').last.toUpperCase(),
          style: const TextStyle(color: Colors.white, fontSize: 10),
        ),
        backgroundColor: color,
        padding: EdgeInsets.zero,
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<TaskStatus>>[
        const PopupMenuItem<TaskStatus>(
          value: TaskStatus.todo,
          child: Text('To Do'),
        ),
        const PopupMenuItem<TaskStatus>(
          value: TaskStatus.inProgress,
          child: Text('In Progress'),
        ),
        const PopupMenuItem<TaskStatus>(
          value: TaskStatus.done,
          child: Text('Done'),
        ),
      ],
    );
  }
}
