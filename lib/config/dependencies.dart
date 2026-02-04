import '../data/datasources/mock_auth_datasource.dart';
import '../data/datasources/mock_employee_datasource.dart';
import '../data/datasources/mock_attendance_datasource.dart';
import '../data/datasources/mock_leave_datasource.dart';
import '../data/datasources/mock_payroll_datasource.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/employee_repository_impl.dart';
import '../data/repositories/attendance_repository_impl.dart';
import '../data/repositories/leave_repository_impl.dart';
import '../data/repositories/payroll_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/employee_repository.dart';
import '../domain/repositories/attendance_repository.dart';
import '../domain/repositories/leave_repository.dart';
import '../domain/repositories/payroll_repository.dart';

class Dependencies {
  // Singleton instance
  static final Dependencies _instance = Dependencies._internal();
  factory Dependencies() => _instance;
  Dependencies._internal();

  // Data Sources (Singletons to maintain state)
  final _authDataSource = MockAuthDataSource();
  final _employeeDataSource = MockEmployeeDataSource();
  final _attendanceDataSource = MockAttendanceDataSource();
  final _leaveDataSource = MockLeaveDataSource();
  final _payrollDataSource = MockPayrollDataSource();

  // Repositories (Lazy initialization)
  late final AuthRepository authRepository = AuthRepositoryImpl(
    _authDataSource,
  );
  late final EmployeeRepository employeeRepository = EmployeeRepositoryImpl(
    _employeeDataSource,
  );
  late final AttendanceRepository attendanceRepository =
      AttendanceRepositoryImpl(_attendanceDataSource);
  late final LeaveRepository leaveRepository = LeaveRepositoryImpl(
    _leaveDataSource,
  );
  late final PayrollRepository payrollRepository = PayrollRepositoryImpl(
    _payrollDataSource,
  );
}
