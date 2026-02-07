import 'package:equatable/equatable.dart';

enum ExpenseStatus { pending, approved, rejected }

enum ExpenseCategory { travel, food, supplies, other }

class ExpenseClaim extends Equatable {
  final String id;
  final String employeeId;
  final DateTime date;
  final double amount;
  final ExpenseCategory category;
  final String description;
  final String? receiptUrl;
  final ExpenseStatus status;

  const ExpenseClaim({
    required this.id,
    required this.employeeId,
    required this.date,
    required this.amount,
    required this.category,
    required this.description,
    this.receiptUrl,
    required this.status,
  });

  @override
  List<Object?> get props => [
    id,
    employeeId,
    date,
    amount,
    category,
    description,
    receiptUrl,
    status,
  ];
}
