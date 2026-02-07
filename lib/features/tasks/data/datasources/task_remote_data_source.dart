import '../../domain/entities/task.dart';
import '../models/task_model.dart';

abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> getTasks();
  Future<TaskModel> createTask(TaskModel task);
  Future<TaskModel> updateTaskStatus(String taskId, TaskStatus status);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  // Mock Data
  final List<TaskModel> _tasks = [
    TaskModel(
      id: '1',
      title: 'Prepare Monthly Report',
      description: 'Compile financial data for Q3 report.',
      assigneeId: 'emp1',
      assigneeName: 'John Doe',
      dueDate: DateTime.now().add(const Duration(days: 2)),
      status: TaskStatus.inProgress,
    ),
    TaskModel(
      id: '2',
      title: 'Update Employee Handbook',
      description: 'Review and update policies in the handbook.',
      assigneeId: 'emp2',
      assigneeName: 'Jane Smith',
      dueDate: DateTime.now().add(const Duration(days: 5)),
      status: TaskStatus.todo,
    ),
  ];

  @override
  Future<List<TaskModel>> getTasks() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _tasks;
  }

  @override
  Future<TaskModel> createTask(TaskModel task) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newTask = TaskModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: task.title,
      description: task.description,
      assigneeId: task.assigneeId,
      assigneeName: task.assigneeName,
      dueDate: task.dueDate,
      status: task.status,
    );
    _tasks.add(newTask);
    return newTask;
  }

  @override
  Future<TaskModel> updateTaskStatus(String taskId, TaskStatus status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      final updatedTask = TaskModel(
        id: _tasks[index].id,
        title: _tasks[index].title,
        description: _tasks[index].description,
        assigneeId: _tasks[index].assigneeId,
        assigneeName: _tasks[index].assigneeName,
        dueDate: _tasks[index].dueDate,
        status: status,
      );
      _tasks[index] = updatedTask;
      return updatedTask;
    } else {
      throw Exception('Task not found');
    }
  }
}
