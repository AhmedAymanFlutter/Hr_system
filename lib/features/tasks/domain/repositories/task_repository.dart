import 'package:dartz/dartz.dart' hide Task;
import '../../../../core/error/failures.dart';
import '../entities/task.dart';

abstract class TaskRepository {
  Future<Either<Failure, List<Task>>> getTasks();
  Future<Either<Failure, Task>> createTask(Task task);
  Future<Either<Failure, Task>> updateTaskStatus(
    String taskId,
    TaskStatus status,
  );
}
