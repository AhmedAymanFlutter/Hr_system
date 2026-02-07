import 'package:dartz/dartz.dart' hide Task;
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

class CreateTask implements UseCase<Either<Failure, Task>, CreateTaskParams> {
  final TaskRepository repository;

  CreateTask(this.repository);

  @override
  Future<Either<Failure, Task>> call(CreateTaskParams params) async {
    return await repository.createTask(params.task);
  }
}

class CreateTaskParams extends Equatable {
  final Task task;

  const CreateTaskParams({required this.task});

  @override
  List<Object> get props => [task];
}
