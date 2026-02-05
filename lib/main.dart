import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/router.dart';
import 'config/injection_container.dart' as di;
import 'config/injection_container.dart'; // import sl
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'features/employees/presentation/cubit/employees_cubit.dart';
import 'features/attendance/presentation/cubit/attendance_cubit.dart';
import 'features/leaves/presentation/cubit/leaves_cubit.dart';
import 'features/bathroom/cubit/bathroom_cubit.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/employee_repository.dart';
import 'domain/repositories/attendance_repository.dart';
import 'domain/repositories/leave_repository.dart';
import 'domain/repositories/payroll_repository.dart';
import 'domain/repositories/bathroom_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: sl<AuthRepository>()),
        RepositoryProvider.value(value: sl<EmployeeRepository>()),
        RepositoryProvider.value(value: sl<AttendanceRepository>()),
        RepositoryProvider.value(value: sl<LeaveRepository>()),
        RepositoryProvider.value(value: sl<PayrollRepository>()),
        RepositoryProvider.value(value: sl<BathroomRepository>()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => sl<AuthCubit>()),
          BlocProvider(create: (_) => sl<DashboardCubit>()),
          BlocProvider(create: (_) => sl<EmployeesCubit>()),
          BlocProvider(create: (_) => sl<AttendanceCubit>()),
          BlocProvider(create: (_) => sl<LeavesCubit>()),
          BlocProvider(create: (_) => sl<BathroomCubit>()),
        ],
        child: MaterialApp.router(
          title: 'HR Management System',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light,
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}
