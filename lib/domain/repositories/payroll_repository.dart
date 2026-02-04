import 'package:hr_system/data/models/payroll_model.dart';

abstract class PayrollRepository {
  Future<List<PayrollModel>> getPayrollByMonth(DateTime month);
  Future<List<PayrollModel>> getPayrollByEmployee(String employeeId);
  Future<PayrollModel> getPayrollById(String id);
  Future<List<PayrollModel>> getUnpaidPayrolls();
  Future<PayrollModel> markAsPaid(String payrollId);
  Future<Map<String, double>> getMonthlyPayrollSummary(DateTime month);
}
