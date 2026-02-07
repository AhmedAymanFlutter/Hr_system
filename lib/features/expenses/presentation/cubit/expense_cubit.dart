import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_system/core/usecases/usecase.dart';
import '../../domain/entities/expense_claim.dart';
import '../../domain/usecases/create_expense.dart';
import '../../domain/usecases/get_my_expenses.dart';
import 'expense_state.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  final GetMyExpenses getMyExpenses;
  final CreateExpense createExpense;

  ExpenseCubit({required this.getMyExpenses, required this.createExpense})
    : super(ExpenseInitial());

  Future<void> loadExpenses() async {
    emit(ExpenseLoading());
    final result = await getMyExpenses(NoParams());
    result.fold(
      (failure) {
        if (!isClosed) emit(ExpenseError(failure.message));
      },
      (expenses) {
        if (!isClosed) emit(ExpenseLoaded(expenses));
      },
    );
  }

  Future<void> submitExpense(ExpenseClaim expense) async {
    emit(ExpenseLoading());
    final result = await createExpense(CreateExpenseParams(expense: expense));
    result.fold(
      (failure) {
        if (!isClosed) emit(ExpenseError(failure.message));
      },
      (newExpense) {
        if (!isClosed) {
          emit(
            const ExpenseOperationSuccess(
              'Expense claim submitted successfully',
            ),
          );
          loadExpenses();
        }
      },
    );
  }
}
