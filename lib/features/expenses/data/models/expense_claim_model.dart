import '../../domain/entities/expense_claim.dart';

class ExpenseClaimModel extends ExpenseClaim {
  const ExpenseClaimModel({
    required super.id,
    required super.employeeId,
    required super.date,
    required super.amount,
    required super.category,
    required super.description,
    super.receiptUrl,
    required super.status,
  });

  factory ExpenseClaimModel.fromJson(Map<String, dynamic> json) {
    return ExpenseClaimModel(
      id: json['id'],
      employeeId: json['employeeId'],
      date: DateTime.parse(json['date']),
      amount: (json['amount'] as num).toDouble(),
      category: ExpenseCategory.values.firstWhere(
        (e) => e.toString().split('.').last == json['category'],
        orElse: () => ExpenseCategory.other,
      ),
      description: json['description'],
      receiptUrl: json['receiptUrl'],
      status: ExpenseStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => ExpenseStatus.pending,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'date': date.toIso8601String(),
      'amount': amount,
      'category': category.toString().split('.').last,
      'description': description,
      'receiptUrl': receiptUrl,
      'status': status.toString().split('.').last,
    };
  }
}
