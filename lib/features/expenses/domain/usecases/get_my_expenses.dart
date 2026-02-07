import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/expense_claim.dart';
import '../repositories/expense_repository.dart';

class GetMyExpenses
    implements UseCase<Either<Failure, List<ExpenseClaim>>, NoParams> {
  final ExpenseRepository repository;

  GetMyExpenses(this.repository);

  @override
  Future<Either<Failure, List<ExpenseClaim>>> call(NoParams params) async {
    return await repository.getMyExpenses();
  }
}
