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
import '../features/chat/presentation/pages/chat_list_page.dart';
import '../features/chat/presentation/pages/chat_detail_page.dart';
import '../features/chat/domain/entities/chat.dart';
import '../features/tasks/presentation/pages/task_list_page.dart';
import '../features/tasks/presentation/pages/add_task_page.dart';
import '../features/announcements/presentation/pages/announcement_list_page.dart';
import '../features/announcements/presentation/pages/create_announcement_page.dart';
import '../features/calendar/presentation/pages/calendar_page.dart';
import '../features/reviews/presentation/pages/review_list_page.dart';
import '../features/reviews/presentation/pages/create_review_page.dart';
import '../features/expenses/presentation/pages/expense_list_page.dart';
import '../features/expenses/presentation/pages/create_expense_page.dart';

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
      GoRoute(
        path: '/chat',
        name: 'chat',
        builder: (context, state) => const ChatListPage(),
        routes: [
          GoRoute(
            path: 'detail',
            name: 'chat_detail',
            builder: (context, state) {
              final chat = state.extra as Chat;
              return ChatDetailPage(chat: chat);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/tasks',
        name: 'tasks',
        builder: (context, state) => const TaskListPage(),
        routes: [
          GoRoute(
            path: 'add',
            name: 'add_task',
            builder: (context, state) => const AddTaskPage(),
          ),
        ],
      ),
      GoRoute(
        path: '/announcements',
        name: 'announcements',
        builder: (context, state) => const AnnouncementListPage(),
        routes: [
          GoRoute(
            path: 'create',
            name: 'create_announcement',
            builder: (context, state) => const CreateAnnouncementPage(),
          ),
        ],
      ),
      GoRoute(
        path: '/calendar',
        name: 'calendar',
        builder: (context, state) => const CalendarPage(),
      ),
      GoRoute(
        path: '/reviews',
        name: 'reviews',
        builder: (context, state) => const ReviewListPage(),
        routes: [
          GoRoute(
            path: 'create',
            name: 'create_review',
            builder: (context, state) => const CreateReviewPage(),
          ),
        ],
      ),
      GoRoute(
        path: '/expenses',
        name: 'expenses',
        builder: (context, state) => const ExpenseListPage(),
        routes: [
          GoRoute(
            path: 'create',
            name: 'create_expense',
            builder: (context, state) => const CreateExpensePage(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
  );
}
