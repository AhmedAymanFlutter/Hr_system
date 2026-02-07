import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/repositories/employee_repository.dart';
import '../../../../domain/repositories/attendance_repository.dart';
import '../../../../domain/repositories/leave_repository.dart';
import '../../../../domain/repositories/payroll_repository.dart';
import '../../../../data/models/user_model.dart';
import '../../data/models/task_model.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final EmployeeRepository employeeRepository;
  final AttendanceRepository attendanceRepository;
  final LeaveRepository leaveRepository;
  final PayrollRepository payrollRepository;

  DashboardCubit({
    required this.employeeRepository,
    required this.attendanceRepository,
    required this.leaveRepository,
    required this.payrollRepository,
  }) : super(const DashboardInitial());

  Future<void> loadDashboardData({UserModel? user}) async {
    emit(const DashboardLoading());

    try {
      if (user != null && user.role == UserRole.employee) {
        // Load Employee Specific Data
        final results = await Future.wait([
          attendanceRepository.getTodayAttendance(), // To check if checked in
          leaveRepository
              .getPendingLeaves(), // Should filter by employee in real app
          payrollRepository.getMonthlyPayrollSummary(
            DateTime.now(),
          ), // Mock returns global, but fine for now
        ]);

        final todayAttendance = results[0] as List;
        final pendingLeaves = results[1] as List;
        // final payrollSummary = results[2] as Map<String, double>;

        // Check if *this* user is checked in
        // In a real app, we'd use getAttendanceByEmployee(user.id) and check for today's entry
        // For mock, we'll simulate it based on random or specific mock data
        final isCheckedIn = todayAttendance.any(
          (att) => (att as dynamic).employeeId == user.id,
        );

        // Generate mock tasks for the employee
        final assignedTasks = [
          TaskModel(
            id: '1',
            title: 'Complete Project Report',
            description: 'Finalize the Q4 report.',
            deadline: DateTime.now().add(const Duration(days: 2)),
            isCompleted: false,
          ),
          TaskModel(
            id: '2',
            title: 'Team Meeting Preparation',
            description: 'Prepare slides for Monday sync.',
            deadline: DateTime.now().add(const Duration(days: 1)),
            isCompleted: false,
          ),
          TaskModel(
            id: '3',
            title: 'Update Documentation',
            description: 'Update the API docs with new endpoints.',
            deadline: DateTime.now().add(const Duration(days: 5)),
            isCompleted: true,
          ),
        ];

        final stats = DashboardStats(
          totalEmployees: 0, // Not relevant for employee
          presentToday: 0, // Not relevant
          pendingLeaves: pendingLeaves
              .where((l) => (l as dynamic).employeeId == user.id)
              .length,
          monthlyPayroll: 5000.0, // Mock personal net salary
          isCheckedIn: isCheckedIn,
          assignedTasks: assignedTasks,
        );
        if (!isClosed) emit(DashboardLoaded(stats));
      } else {
        // Load Admin/HR Data (Existing Logic)
        final results = await Future.wait([
          employeeRepository.getAllEmployees(),
          attendanceRepository.getTodayAttendance(),
          leaveRepository.getPendingLeaves(),
          payrollRepository.getMonthlyPayrollSummary(DateTime.now()),
        ]);

        final employees = results[0] as List;
        final todayAttendance = results[1] as List;
        final pendingLeaves = results[2] as List;
        final payrollSummary = results[3] as Map<String, double>;

        // Mock Activity Log
        final recentActivity = [
          ActivityLog(
            id: '1',
            title: 'Sarah Johnson',
            subtitle: 'Checked in at 09:00 AM',
            timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
            type: 'attendance',
          ),
          ActivityLog(
            id: '2',
            title: 'John Doe',
            subtitle: 'Requested Sick Leave',
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
            type: 'leave',
          ),
          ActivityLog(
            id: '3',
            title: 'System',
            subtitle: 'Payroll generated for July',
            timestamp: DateTime.now().subtract(const Duration(days: 1)),
            type: 'payroll',
          ),
        ];

        final stats = DashboardStats(
          totalEmployees: employees.length,
          presentToday: todayAttendance.length,
          pendingLeaves: pendingLeaves.length,
          monthlyPayroll: payrollSummary['netSalary'] ?? 0,
          recentActivity: recentActivity,
          trends: {
            'employees': 12.5, // +12.5%
            'attendance': -2.0, // -2%
            'payroll': 5.4,
          },
        );

        if (!isClosed) emit(DashboardLoaded(stats));
      }
    } catch (e) {
      if (!isClosed) emit(DashboardError(e.toString()));
    }
  }

  void refresh({UserModel? user}) {
    loadDashboardData(user: user);
  }
}
