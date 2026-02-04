import '../../data/models/employee_model.dart';

abstract class EmployeeRepository {
  Future<List<EmployeeModel>> getAllEmployees();
  Future<EmployeeModel> getEmployeeById(String id);
  Future<List<EmployeeModel>> getEmployeesByDepartment(String department);
  Future<EmployeeModel> addEmployee(EmployeeModel employee);
  Future<EmployeeModel> updateEmployee(EmployeeModel employee);
  Future<void> deleteEmployee(String id);
  Future<List<String>> getDepartments();
}
