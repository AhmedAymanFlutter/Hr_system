import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/expense_claim.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_remote_data_source.dart';
import '../models/expense_claim_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseRemoteDataSource remoteDataSource;

  ExpenseRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ExpenseClaim>>> getMyExpenses() async {
    try {
      final expenses = await remoteDataSource.getMyExpenses();
      return Right<Failure, List<ExpenseClaim>>(expenses);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ExpenseClaim>> createExpense(
    ExpenseClaim expense,
  ) async {
    try {
      final expenseModel = ExpenseClaimModel(
        id: expense.id,
        employeeId: expense.employeeId,
        date: expense.date,
        amount: expense.amount,
        category: expense.category,
        description: expense.description,
        receiptUrl: expense.receiptUrl,
        status: expense.status,
      );
      final createdExpense = await remoteDataSource.createExpense(expenseModel);
      return Right<Failure, ExpenseClaim>(createdExpense);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
