import '../models/expense_claim_model.dart';
import '../../domain/entities/expense_claim.dart';

abstract class ExpenseRemoteDataSource {
  Future<List<ExpenseClaimModel>> getMyExpenses();
  Future<ExpenseClaimModel> createExpense(ExpenseClaimModel expense);
}

class ExpenseRemoteDataSourceImpl implements ExpenseRemoteDataSource {
  // Mock Data
  final List<ExpenseClaimModel> _expenses = [
    ExpenseClaimModel(
      id: '1',
      employeeId: 'emp1',
      date: DateTime.now().subtract(const Duration(days: 5)),
      amount: 150.0,
      category: ExpenseCategory.travel,
      description: 'Taxi to airport',
      status: ExpenseStatus.approved,
    ),
    ExpenseClaimModel(
      id: '2',
      employeeId: 'emp1',
      date: DateTime.now().subtract(const Duration(days: 2)),
      amount: 45.0,
      category: ExpenseCategory.food,
      description: 'Team lunch',
      status: ExpenseStatus.pending,
    ),
  ];

  @override
  Future<List<ExpenseClaimModel>> getMyExpenses() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _expenses;
  }

  @override
  Future<ExpenseClaimModel> createExpense(ExpenseClaimModel expense) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    final newExpense = ExpenseClaimModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      employeeId: expense.employeeId,
      date: expense.date,
      amount: expense.amount,
      category: expense.category,
      description: expense.description,
      receiptUrl: expense.receiptUrl,
      status: ExpenseStatus.pending,
    );
    _expenses.insert(0, newExpense);
    return newExpense;
  }
}
