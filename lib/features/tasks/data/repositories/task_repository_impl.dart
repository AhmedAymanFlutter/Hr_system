import 'package:dartz/dartz.dart' hide Task;
import '../../../../core/error/failures.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_remote_data_source.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Task>>> getTasks() async {
    try {
      final tasks = await remoteDataSource.getTasks();
      return Right<Failure, List<Task>>(tasks);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Task>> createTask(Task task) async {
    try {
      final taskModel = TaskModel(
        id: task.id,
        title: task.title,
        description: task.description,
        assigneeId: task.assigneeId,
        assigneeName: task.assigneeName,
        dueDate: task.dueDate,
        status: task.status,
      );
      final createdTask = await remoteDataSource.createTask(taskModel);
      return Right<Failure, Task>(createdTask);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Task>> updateTaskStatus(
    String taskId,
    TaskStatus status,
  ) async {
    try {
      final updatedTask = await remoteDataSource.updateTaskStatus(
        taskId,
        status,
      );
      return Right<Failure, Task>(updatedTask);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
