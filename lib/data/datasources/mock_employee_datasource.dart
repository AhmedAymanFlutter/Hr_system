import '../models/employee_model.dart';

class MockEmployeeDataSource {
  // Simulate network delay
  Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  // Mock employees database
  final List<EmployeeModel> _mockEmployees = [
    EmployeeModel(
      id: '1',
      name: 'John Doe',
      email: 'john.doe@company.com',
      phone: '+1 555-0101',
      department: 'Engineering',
      position: 'Software Engineer',
      status: EmployeeStatus.active,
      joinDate: DateTime(2022, 1, 15),
      salary: 75000,
      address: '123 Main St, New York, NY 10001',
      dateOfBirth: DateTime(1990, 5, 20),
      emergencyContact: '+1 555-0199',
    ),
    EmployeeModel(
      id: '2',
      name: 'Sarah Johnson',
      email: 'sarah.johnson@company.com',
      phone: '+1 555-0102',
      department: 'Human Resources',
      position: 'HR Manager',
      status: EmployeeStatus.active,
      joinDate: DateTime(2020, 3, 10),
      salary: 85000,
      address: '456 Elm St, New York, NY 10002',
      dateOfBirth: DateTime(1988, 8, 15),
      emergencyContact: '+1 555-0198',
    ),
    EmployeeModel(
      id: '3',
      name: 'Michael Chen',
      email: 'michael.chen@company.com',
      phone: '+1 555-0103',
      department: 'Engineering',
      position: 'Senior Developer',
      status: EmployeeStatus.active,
      joinDate: DateTime(2019, 6, 20),
      salary: 95000,
      address: '789 Oak St, New York, NY 10003',
      dateOfBirth: DateTime(1985, 3, 12),
      emergencyContact: '+1 555-0197',
    ),
    EmployeeModel(
      id: '4',
      name: 'Emily Williams',
      email: 'emily.williams@company.com',
      phone: '+1 555-0104',
      department: 'Marketing',
      position: 'Marketing Specialist',
      status: EmployeeStatus.active,
      joinDate: DateTime(2021, 9, 5),
      salary: 65000,
      address: '321 Pine St, New York, NY 10004',
      dateOfBirth: DateTime(1992, 11, 8),
      emergencyContact: '+1 555-0196',
    ),
    EmployeeModel(
      id: '5',
      name: 'David Brown',
      email: 'david.brown@company.com',
      phone: '+1 555-0105',
      department: 'Sales',
      position: 'Sales Manager',
      status: EmployeeStatus.active,
      joinDate: DateTime(2018, 2, 14),
      salary: 90000,
      address: '654 Maple St, New York, NY 10005',
      dateOfBirth: DateTime(1987, 7, 25),
      emergencyContact: '+1 555-0195',
    ),
    EmployeeModel(
      id: '6',
      name: 'Lisa Anderson',
      email: 'lisa.anderson@company.com',
      phone: '+1 555-0106',
      department: 'Finance',
      position: 'Accountant',
      status: EmployeeStatus.onLeave,
      joinDate: DateTime(2020, 11, 22),
      salary: 70000,
      address: '987 Cedar St, New York, NY 10006',
      dateOfBirth: DateTime(1991, 4, 18),
      emergencyContact: '+1 555-0194',
    ),
  ];

  Future<List<EmployeeModel>> getAllEmployees() async {
    await _simulateDelay();
    return List.from(_mockEmployees);
  }

  Future<EmployeeModel> getEmployeeById(String id) async {
    await _simulateDelay();
    return _mockEmployees.firstWhere(
      (e) => e.id == id,
      orElse: () => throw Exception('Employee not found'),
    );
  }

  Future<List<EmployeeModel>> getEmployeesByDepartment(
    String department,
  ) async {
    await _simulateDelay();
    return _mockEmployees.where((e) => e.department == department).toList();
  }

  Future<EmployeeModel> addEmployee(EmployeeModel employee) async {
    await _simulateDelay();
    final newEmployee = employee.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    _mockEmployees.add(newEmployee);
    return newEmployee;
  }

  Future<EmployeeModel> updateEmployee(EmployeeModel employee) async {
    await _simulateDelay();
    final index = _mockEmployees.indexWhere((e) => e.id == employee.id);
    if (index == -1) {
      throw Exception('Employee not found');
    }
    _mockEmployees[index] = employee;
    return employee;
  }

  Future<void> deleteEmployee(String id) async {
    await _simulateDelay();
    _mockEmployees.removeWhere((e) => e.id == id);
  }

  Future<List<String>> getDepartments() async {
    await _simulateDelay();
    return _mockEmployees.map((e) => e.department).toSet().toList();
  }
}
