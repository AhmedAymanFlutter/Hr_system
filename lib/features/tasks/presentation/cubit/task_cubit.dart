import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_system/core/usecases/usecase.dart';
import 'package:hr_system/features/tasks/domain/entities/task.dart';
import 'package:hr_system/features/tasks/domain/usecases/create_task.dart';
import 'package:hr_system/features/tasks/domain/usecases/get_tasks.dart';
import 'package:hr_system/features/tasks/domain/usecases/update_task_status.dart';
import 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final GetTasks getTasks;
  final CreateTask createTask;
  final UpdateTaskStatus updateTaskStatus;

  TaskCubit({
    required this.getTasks,
    required this.createTask,
    required this.updateTaskStatus,
  }) : super(TaskInitial());

  Future<void> loadTasks() async {
    emit(TaskLoading());
    final result = await getTasks(NoParams());
    result.fold(
      (failure) {
        if (!isClosed) emit(TaskError(failure.message));
      },
      (tasks) {
        if (!isClosed) emit(TaskLoaded(tasks));
      },
    );
  }

  Future<void> addNewTask(Task task) async {
    emit(TaskLoading());
    final result = await createTask(CreateTaskParams(task: task));
    result.fold(
      (failure) {
        if (!isClosed) emit(TaskError(failure.message));
      },
      (newTask) {
        if (!isClosed) {
          emit(const TaskOperationSuccess('Task created successfully'));
          loadTasks(); // Reload tasks after adding
        }
      },
    );
  }

  Future<void> updateStatus(String taskId, TaskStatus status) async {
    // Optimistic update could be implemented here, but simple reload for now
    final result = await updateTaskStatus(
      UpdateTaskStatusParams(taskId: taskId, status: status),
    );
    result.fold(
      (failure) {
        if (!isClosed) emit(TaskError(failure.message));
      },
      (updatedTask) {
        // We could just update the specific task in the list if we had the current list state access easily
        // But reloading is safer for consistency in this simple implementation
        if (!isClosed) loadTasks();
      },
    );
  }
}
