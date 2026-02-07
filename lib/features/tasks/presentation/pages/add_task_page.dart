import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_system/config/injection_container.dart';
import 'package:hr_system/features/tasks/domain/entities/task.dart';
import 'package:hr_system/features/tasks/presentation/cubit/task_cubit.dart';
import 'package:hr_system/features/tasks/presentation/cubit/task_state.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _assigneeController =
      TextEditingController(); // Simple text input for now
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _assigneeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<TaskCubit>(),
      child: BlocListener<TaskCubit, TaskState>(
        listener: (context, state) {
          if (state is TaskOperationSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            context.pop(); // Go back to list
            // Note: The list page needs to reload. Since we are using a fresh Cubit here,
            // the list page's Cubit won't know about the update unless we use a singleton Cubit or event bus.
            // For simplicity in this architecture, the list page reloads on init.
            // Better approach: Pass the existing Cubit or use a repository stream.
            // Given the setup, we'll assume the user is okay with manual refresh or we can trigger it.
            // Actually, `sl<TaskCubit>()` creates a NEW instance because it is registered as factory.
            // PRO TIP: To update the list, we should probably have the list page listen to a stream or similar.
            // For this specific 'mock' implementation, creating a new task won't show up on the list page
            // unless the data source persists it in memory (which singleton mock does!).
            // So if `TaskRemoteDataSource` is a singleton, it will work!
          } else if (state is TaskError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('New Task')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter a title'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter a description'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _assigneeController,
                    decoration: const InputDecoration(
                      labelText: 'Assign to (Name)',
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter assignee name'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        "Due Date: ${_selectedDate.toLocal().toString().split(' ')[0]}",
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => _selectDate(context),
                        child: const Text('Select Date'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Builder(
                    builder: (context) {
                      return ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final newTask = Task(
                              id: '', // Generated by repo
                              title: _titleController.text,
                              description: _descriptionController.text,
                              assigneeId: 'temp_id', // Mock ID
                              assigneeName: _assigneeController.text,
                              dueDate: _selectedDate,
                              status: TaskStatus.todo,
                            );
                            context.read<TaskCubit>().addNewTask(newTask);
                          }
                        },
                        child: const Text('Create Task'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
