import 'package:equatable/equatable.dart';

class PayrollModel extends Equatable {
  final String id;
  final String employeeId;
  final String employeeName;
  final DateTime month;
  final double basicSalary;
  final double allowances;
  final double bonuses;
  final double deductions;
  final double taxAmount;
  final double netSalary;
  final bool isPaid;
  final DateTime? paidDate;
  final Map<String, double> allowanceBreakdown;
  final Map<String, double> deductionBreakdown;

  const PayrollModel({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.month,
    required this.basicSalary,
    required this.allowances,
    required this.bonuses,
    required this.deductions,
    required this.taxAmount,
    required this.netSalary,
    required this.isPaid,
    this.paidDate,
    this.allowanceBreakdown = const {},
    this.deductionBreakdown = const {},
  });

  factory PayrollModel.fromJson(Map<String, dynamic> json) {
    return PayrollModel(
      id: json['id'] as String,
      employeeId: json['employeeId'] as String,
      employeeName: json['employeeName'] as String,
      month: DateTime.parse(json['month'] as String),
      basicSalary: (json['basicSalary'] as num).toDouble(),
      allowances: (json['allowances'] as num).toDouble(),
      bonuses: (json['bonuses'] as num).toDouble(),
      deductions: (json['deductions'] as num).toDouble(),
      taxAmount: (json['taxAmount'] as num).toDouble(),
      netSalary: (json['netSalary'] as num).toDouble(),
      isPaid: json['isPaid'] as bool,
      paidDate: json['paidDate'] != null
          ? DateTime.parse(json['paidDate'] as String)
          : null,
      allowanceBreakdown:
          (json['allowanceBreakdown'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, (v as num).toDouble()),
          ) ??
          {},
      deductionBreakdown:
          (json['deductionBreakdown'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, (v as num).toDouble()),
          ) ??
          {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'employeeName': employeeName,
      'month': month.toIso8601String(),
      'basicSalary': basicSalary,
      'allowances': allowances,
      'bonuses': bonuses,
      'deductions': deductions,
      'taxAmount': taxAmount,
      'netSalary': netSalary,
      'isPaid': isPaid,
      'paidDate': paidDate?.toIso8601String(),
      'allowanceBreakdown': allowanceBreakdown,
      'deductionBreakdown': deductionBreakdown,
    };
  }

  PayrollModel copyWith({
    String? id,
    String? employeeId,
    String? employeeName,
    DateTime? month,
    double? basicSalary,
    double? allowances,
    double? bonuses,
    double? deductions,
    double? taxAmount,
    double? netSalary,
    bool? isPaid,
    DateTime? paidDate,
    Map<String, double>? allowanceBreakdown,
    Map<String, double>? deductionBreakdown,
  }) {
    return PayrollModel(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      month: month ?? this.month,
      basicSalary: basicSalary ?? this.basicSalary,
      allowances: allowances ?? this.allowances,
      bonuses: bonuses ?? this.bonuses,
      deductions: deductions ?? this.deductions,
      taxAmount: taxAmount ?? this.taxAmount,
      netSalary: netSalary ?? this.netSalary,
      isPaid: isPaid ?? this.isPaid,
      paidDate: paidDate ?? this.paidDate,
      allowanceBreakdown: allowanceBreakdown ?? this.allowanceBreakdown,
      deductionBreakdown: deductionBreakdown ?? this.deductionBreakdown,
    );
  }

  @override
  List<Object?> get props => [
    id,
    employeeId,
    employeeName,
    month,
    basicSalary,
    allowances,
    bonuses,
    deductions,
    taxAmount,
    netSalary,
    isPaid,
    paidDate,
    allowanceBreakdown,
    deductionBreakdown,
  ];
}
