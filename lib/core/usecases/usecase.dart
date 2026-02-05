import 'package:equatable/equatable.dart';
import '../error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

sealed class Result<S, F> {
  const Result();
}

class Success<S, F> extends Result<S, F> {
  final S value;
  const Success(this.value);
}

class Error<S, F> extends Result<S, F> {
  final F failure;
  const Error(this.failure);
}

abstract class BaseUseCase<Type, Params> {
  Future<Result<Type, Failure>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
