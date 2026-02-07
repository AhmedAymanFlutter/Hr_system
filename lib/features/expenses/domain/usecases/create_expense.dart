import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/expense_claim.dart';
import '../repositories/expense_repository.dart';

class CreateExpense
    implements UseCase<Either<Failure, ExpenseClaim>, CreateExpenseParams> {
  final ExpenseRepository repository;

  CreateExpense(this.repository);

  @override
  Future<Either<Failure, ExpenseClaim>> call(CreateExpenseParams params) async {
    return await repository.createExpense(params.expense);
  }
}

class CreateExpenseParams extends Equatable {
  final ExpenseClaim expense;

  const CreateExpenseParams({required this.expense});

  @override
  List<Object> get props => [expense];
}
