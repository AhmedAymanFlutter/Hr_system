import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';
import '../features/employees/presentation/pages/employees_list_page.dart';
import '../features/attendance/presentation/pages/attendance_page.dart';
import '../features/leaves/presentation/pages/leave_requests_page.dart';
import '../features/payroll/presentation/pages/payroll_page.dart';
import '../features/bathroom/pages/bathroom_page.dart';
import '../features/bathroom/cubit/bathroom_cubit.dart';
import '../domain/repositories/bathroom_repository.dart';
import '../domain/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      GoRoute(
        path: '/bathroom',
        name: 'bathroom',
        builder: (context, state) => BlocProvider(
          create: (context) => BathroomCubit(
            bathroomRepository: context.read<BathroomRepository>(),
            authRepository: context.read<AuthRepository>(),
          ),
          child: const BathroomPage(),
        ),
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
  );
}
