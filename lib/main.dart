import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/router.dart';
import 'config/dependencies.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'features/employees/presentation/cubit/employees_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final dependencies = Dependencies();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: dependencies.authRepository),
        RepositoryProvider.value(value: dependencies.employeeRepository),
        RepositoryProvider.value(value: dependencies.attendanceRepository),
        RepositoryProvider.value(value: dependencies.leaveRepository),
        RepositoryProvider.value(value: dependencies.payrollRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthCubit(dependencies.authRepository),
          ),
          BlocProvider(
            create: (context) => DashboardCubit(
              employeeRepository: dependencies.employeeRepository,
              attendanceRepository: dependencies.attendanceRepository,
              leaveRepository: dependencies.leaveRepository,
              payrollRepository: dependencies.payrollRepository,
            ),
          ),
          BlocProvider(
            create: (context) =>
                EmployeesCubit(dependencies.employeeRepository),
          ),
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
