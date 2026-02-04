import '../models/payroll_model.dart';

class MockPayrollDataSource {
  // Simulate network delay
  Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  // Generate mock payroll for the past 6 months
  List<PayrollModel> _generateMockPayroll() {
    final List<PayrollModel> payrolls = [];
    final now = DateTime.now();

    final employees = [
      {'id': '1', 'name': 'John Doe', 'salary': 75000.0},
      {'id': '2', 'name': 'Sarah Johnson', 'salary': 85000.0},
      {'id': '3', 'name': 'Michael Chen', 'salary': 95000.0},
      {'id': '4', 'name': 'Emily Williams', 'salary': 65000.0},
      {'id': '5', 'name': 'David Brown', 'salary': 90000.0},
      {'id': '6', 'name': 'Lisa Anderson', 'salary': 70000.0},
    ];

    for (int monthOffset = 0; monthOffset < 6; monthOffset++) {
      final month = DateTime(now.year, now.month - monthOffset, 1);

      for (final emp in employees) {
        final basicSalary = (emp['salary'] as double) / 12;
        final allowances = basicSalary * 0.15; // 15% allowances
        final bonuses = monthOffset == 0
            ? basicSalary * 0.1
            : 0.0; // Bonus this month
        final deductions = basicSalary * 0.05; // 5% deductions
        final taxAmount = basicSalary * 0.20; // 20% tax
        final netSalary =
            basicSalary + allowances + bonuses - deductions - taxAmount;

        payrolls.add(
          PayrollModel(
            id: 'payroll_${emp['id']}_${month.millisecondsSinceEpoch}',
            employeeId: emp['id'] as String,
            employeeName: emp['name'] as String,
            month: month,
            basicSalary: basicSalary,
            allowances: allowances,
            bonuses: bonuses,
            deductions: deductions,
            taxAmount: taxAmount,
            netSalary: netSalary,
            isPaid: monthOffset > 0, // Only current month is unpaid
            paidDate: monthOffset > 0
                ? month.add(const Duration(days: 25))
                : null,
            allowanceBreakdown: {
              'Housing': basicSalary * 0.08,
              'Transport': basicSalary * 0.05,
              'Food': basicSalary * 0.02,
            },
            deductionBreakdown: {
              'Insurance': basicSalary * 0.03,
              'Pension': basicSalary * 0.02,
            },
          ),
        );
      }
    }

    return payrolls;
  }

  late final List<PayrollModel> _mockPayrolls = _generateMockPayroll();

  Future<List<PayrollModel>> getPayrollByMonth(DateTime month) async {
    await _simulateDelay();
    return _mockPayrolls.where((p) {
      return p.month.year == month.year && p.month.month == month.month;
    }).toList();
  }

  Future<List<PayrollModel>> getPayrollByEmployee(String employeeId) async {
    await _simulateDelay();
    return _mockPayrolls.where((p) => p.employeeId == employeeId).toList();
  }

  Future<PayrollModel> getPayrollById(String id) async {
    await _simulateDelay();
    return _mockPayrolls.firstWhere(
      (p) => p.id == id,
      orElse: () => throw Exception('Payroll not found'),
    );
  }

  Future<List<PayrollModel>> getUnpaidPayrolls() async {
    await _simulateDelay();
    return _mockPayrolls.where((p) => !p.isPaid).toList();
  }

  Future<PayrollModel> markAsPaid(String payrollId) async {
    await _simulateDelay();
    final index = _mockPayrolls.indexWhere((p) => p.id == payrollId);
    if (index == -1) {
      throw Exception('Payroll not found');
    }

    final updated = _mockPayrolls[index].copyWith(
      isPaid: true,
      paidDate: DateTime.now(),
    );
    _mockPayrolls[index] = updated;
    return updated;
  }

  Future<Map<String, double>> getMonthlyPayrollSummary(DateTime month) async {
    await _simulateDelay();
    final payrolls = await getPayrollByMonth(month);

    double totalBasic = 0;
    double totalAllowances = 0;
    double totalBonuses = 0;
    double totalDeductions = 0;
    double totalTax = 0;
    double totalNet = 0;

    for (final payroll in payrolls) {
      totalBasic += payroll.basicSalary;
      totalAllowances += payroll.allowances;
      totalBonuses += payroll.bonuses;
      totalDeductions += payroll.deductions;
      totalTax += payroll.taxAmount;
      totalNet += payroll.netSalary;
    }

    return {
      'basicSalary': totalBasic,
      'allowances': totalAllowances,
      'bonuses': totalBonuses,
      'deductions': totalDeductions,
      'tax': totalTax,
      'netSalary': totalNet,
    };
  }
}
