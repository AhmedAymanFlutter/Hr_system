import '../../domain/repositories/payroll_repository.dart';
import '../datasources/mock_payroll_datasource.dart';
import '../models/payroll_model.dart';

class PayrollRepositoryImpl implements PayrollRepository {
  final MockPayrollDataSource dataSource;

  PayrollRepositoryImpl(this.dataSource);

  @override
  Future<List<PayrollModel>> getPayrollByMonth(DateTime month) async {
    try {
      return await dataSource.getPayrollByMonth(month);
    } catch (e) {
      throw Exception('Failed to get payroll: ${e.toString()}');
    }
  }

  @override
  Future<List<PayrollModel>> getPayrollByEmployee(String employeeId) async {
    try {
      return await dataSource.getPayrollByEmployee(employeeId);
    } catch (e) {
      throw Exception('Failed to get employee payroll: ${e.toString()}');
    }
  }

  @override
  Future<PayrollModel> getPayrollById(String id) async {
    try {
      return await dataSource.getPayrollById(id);
    } catch (e) {
      throw Exception('Failed to get payroll: ${e.toString()}');
    }
  }

  @override
  Future<List<PayrollModel>> getUnpaidPayrolls() async {
    try {
      return await dataSource.getUnpaidPayrolls();
    } catch (e) {
      throw Exception('Failed to get unpaid payrolls: ${e.toString()}');
    }
  }

  @override
  Future<PayrollModel> markAsPaid(String payrollId) async {
    try {
      return await dataSource.markAsPaid(payrollId);
    } catch (e) {
      throw Exception('Failed to mark payroll as paid: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, double>> getMonthlyPayrollSummary(DateTime month) async {
    try {
      return await dataSource.getMonthlyPayrollSummary(month);
    } catch (e) {
      throw Exception('Failed to get payroll summary: ${e.toString()}');
    }
  }
}
