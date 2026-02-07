import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/expense_claim.dart';

abstract class ExpenseRepository {
  Future<Either<Failure, List<ExpenseClaim>>> getMyExpenses();
  Future<Either<Failure, ExpenseClaim>> createExpense(ExpenseClaim expense);
}
