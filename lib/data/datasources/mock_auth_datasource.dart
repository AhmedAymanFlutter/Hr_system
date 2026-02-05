import '../models/user_model.dart';

class MockAuthDataSource {
  // Simulate network delay
  Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  // Mock users database
  final List<UserModel> _mockUsers = [
    const UserModel(
      id: '1',
      email: 'admin@hr.com',
      name: 'Admin User',
      role: UserRole.admin,
      department: 'Management',
      position: 'System Administrator',
    ),
    const UserModel(
      id: '2',
      email: 'hr@hr.com',
      name: 'Sarah Johnson',
      role: UserRole.hr,
      department: 'Human Resources',
      position: 'HR Manager',
    ),
    const UserModel(
      id: '3',
      email: 'employee@hr.com',
      name: 'John Doe',
      role: UserRole.employee,
      department: 'Engineering',
      position: 'Software Engineer',
    ),
  ];

  UserModel? _currentUser;

  Future<UserModel> login(String email, String password) async {
    await _simulateDelay();

    // For demo purposes, accept any password
    final user = _mockUsers.firstWhere(
      (u) => u.email.toLowerCase() == email.toLowerCase(),
      orElse: () => throw Exception('Invalid email or password'),
    );

    _currentUser = user;
    return user;
  }

  Future<void> logout() async {
    await _simulateDelay();
    _currentUser = null;
  }

  Future<UserModel?> getCurrentUser() async {
    await _simulateDelay(); // Keep delay to simulate network, but return actual user
    return _currentUser;
  }
}
