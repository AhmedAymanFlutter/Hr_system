import '../../domain/repositories/employee_repository.dart';
import '../datasources/mock_employee_datasource.dart';
import '../models/employee_model.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final MockEmployeeDataSource dataSource;

  EmployeeRepositoryImpl(this.dataSource);

  @override
  Future<List<EmployeeModel>> getAllEmployees() async {
    try {
      return await dataSource.getAllEmployees();
    } catch (e) {
      throw Exception('Failed to get employees: ${e.toString()}');
    }
  }

  @override
  Future<EmployeeModel> getEmployeeById(String id) async {
    try {
      return await dataSource.getEmployeeById(id);
    } catch (e) {
      throw Exception('Failed to get employee: ${e.toString()}');
    }
  }

  @override
  Future<List<EmployeeModel>> getEmployeesByDepartment(
    String department,
  ) async {
    try {
      return await dataSource.getEmployeesByDepartment(department);
    } catch (e) {
      throw Exception('Failed to get employees by department: ${e.toString()}');
    }
  }

  @override
  Future<EmployeeModel> addEmployee(EmployeeModel employee) async {
    try {
      return await dataSource.addEmployee(employee);
    } catch (e) {
      throw Exception('Failed to add employee: ${e.toString()}');
    }
  }

  @override
  Future<EmployeeModel> updateEmployee(EmployeeModel employee) async {
    try {
      return await dataSource.updateEmployee(employee);
    } catch (e) {
      throw Exception('Failed to update employee: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteEmployee(String id) async {
    try {
      await dataSource.deleteEmployee(id);
    } catch (e) {
      throw Exception('Failed to delete employee: ${e.toString()}');
    }
  }

  @override
  Future<List<String>> getDepartments() async {
    try {
      return await dataSource.getDepartments();
    } catch (e) {
      throw Exception('Failed to get departments: ${e.toString()}');
    }
  }
}
