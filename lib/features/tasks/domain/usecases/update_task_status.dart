import 'package:dartz/dartz.dart' hide Task;
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

class UpdateTaskStatus
    implements UseCase<Either<Failure, Task>, UpdateTaskStatusParams> {
  final TaskRepository repository;

  UpdateTaskStatus(this.repository);

  @override
  Future<Either<Failure, Task>> call(UpdateTaskStatusParams params) async {
    return await repository.updateTaskStatus(params.taskId, params.status);
  }
}

class UpdateTaskStatusParams extends Equatable {
  final String taskId;
  final TaskStatus status;

  const UpdateTaskStatusParams({required this.taskId, required this.status});

  @override
  List<Object> get props => [taskId, status];
}
