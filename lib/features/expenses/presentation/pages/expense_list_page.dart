import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_system/config/injection_container.dart';
import 'package:hr_system/core/theme/app_colors.dart';
import '../../domain/entities/expense_claim.dart';
import '../cubit/expense_cubit.dart';
import '../cubit/expense_state.dart';

class ExpenseListPage extends StatelessWidget {
  const ExpenseListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ExpenseCubit>()..loadExpenses(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Expense Reimbursement')),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.push('/expenses/create'),
          child: const Icon(Icons.add),
        ),
        body: BlocBuilder<ExpenseCubit, ExpenseState>(
          builder: (context, state) {
            if (state is ExpenseLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ExpenseLoaded) {
              if (state.expenses.isEmpty) {
                return const Center(child: Text('No expense claims yet'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.expenses.length,
                itemBuilder: (context, index) {
                  final expense = state.expenses[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.background,
                        child: Icon(
                          _getCategoryIcon(expense.category),
                          color: AppColors.secondary,
                        ),
                      ),
                      title: Text(
                        expense.description,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Date: ${expense.date.day}/${expense.date.month}/${expense.date.year}",
                          ),
                          Text(
                            expense.status
                                .toString()
                                .split('.')
                                .last
                                .toUpperCase(),
                            style: TextStyle(
                              color: _getStatusColor(expense.status),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      trailing: Text(
                        "\$${expense.amount.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state is ExpenseError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  IconData _getCategoryIcon(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.travel:
        return Icons.flight;
      case ExpenseCategory.food:
        return Icons.restaurant;
      case ExpenseCategory.supplies:
        return Icons.inventory;
      case ExpenseCategory.other:
        return Icons.receipt;
    }
  }

  Color _getStatusColor(ExpenseStatus status) {
    switch (status) {
      case ExpenseStatus.pending:
        return Colors.orange;
      case ExpenseStatus.approved:
        return Colors.green;
      case ExpenseStatus.rejected:
        return Colors.red;
    }
  }
}
