import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';
import '../features/employees/presentation/pages/employees_list_page.dart';
import '../features/attendance/presentation/pages/attendance_page.dart';
import '../features/leaves/presentation/pages/leave_requests_page.dart';
import '../features/payroll/presentation/pages/payroll_page.dart';

class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: '/employees',
        name: 'employees',
        builder: (context, state) => const EmployeesListPage(),
      ),
      GoRoute(
        path: '/attendance',
        name: 'attendance',
        builder: (context, state) => const AttendancePage(),
      ),
      GoRoute(
        path: '/leaves',
        name: 'leaves',
        builder: (context, state) => const LeaveRequestsPage(),
      ),
      GoRoute(
        path: '/payroll',
        name: 'payroll',
        builder: (context, state) => const PayrollPage(),
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
  );
}
