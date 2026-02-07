import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/network/api_client.dart';

// DataSources
import '../data/datasources/auth_local_datasource.dart';
import '../data/datasources/mock_auth_datasource.dart';
import '../data/datasources/mock_employee_datasource.dart';
import '../data/datasources/mock_attendance_datasource.dart';
import '../data/datasources/mock_leave_datasource.dart';
import '../data/datasources/mock_payroll_datasource.dart';
import '../data/datasources/mock_bathroom_datasource.dart';

// UseCases
import '../features/auth/domain/usecases/login_usecase.dart';
import '../features/auth/domain/usecases/logout_usecase.dart';
import '../features/auth/domain/usecases/get_current_user_usecase.dart';

import '../features/employees/domain/usecases/get_employees_usecase.dart';
import '../features/employees/domain/usecases/add_employee_usecase.dart';
import '../features/employees/domain/usecases/update_employee_usecase.dart';

import '../features/attendance/domain/usecases/get_attendance_usecase.dart';
import '../features/attendance/domain/usecases/check_in_usecase.dart';
import '../features/attendance/domain/usecases/check_out_usecase.dart';
import '../features/attendance/presentation/cubit/attendance_cubit.dart';

import '../features/leaves/domain/usecases/get_leaves_usecase.dart';
import '../features/leaves/domain/usecases/submit_leave_usecase.dart';
import '../features/leaves/domain/usecases/approve_leave_usecase.dart';
import '../features/leaves/domain/usecases/reject_leave_usecase.dart';
import '../features/leaves/presentation/cubit/leaves_cubit.dart';

// Repositories
import '../domain/repositories/auth_repository.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/employee_repository.dart';
import '../data/repositories/employee_repository_impl.dart';
import '../domain/repositories/attendance_repository.dart';
import '../data/repositories/attendance_repository_impl.dart';
import '../domain/repositories/leave_repository.dart';
import '../data/repositories/leave_repository_impl.dart';
import '../domain/repositories/payroll_repository.dart';
import '../data/repositories/payroll_repository_impl.dart';
import '../domain/repositories/bathroom_repository.dart';
import '../data/repositories/bathroom_repository_impl.dart';

// Cubits
import '../features/auth/presentation/cubit/auth_cubit.dart';
import '../features/dashboard/presentation/cubit/dashboard_cubit.dart';
import '../features/employees/presentation/cubit/employees_cubit.dart';
import '../features/bathroom/cubit/bathroom_cubit.dart';

// Chat Features
import '../features/chat/domain/usecases/get_chats.dart';
import '../features/chat/domain/usecases/get_messages.dart';
import '../features/chat/domain/usecases/send_message.dart';
import '../features/chat/presentation/cubit/chat_list/chat_list_cubit.dart';
import '../features/chat/presentation/cubit/chat_detail/chat_detail_cubit.dart';
import '../features/chat/domain/repositories/chat_repository.dart';
import '../features/chat/data/repositories/chat_repository_impl.dart';
import '../features/chat/data/datasources/chat_remote_data_source.dart';

// Tasks Features
import '../features/tasks/domain/usecases/get_tasks.dart';
import '../features/tasks/domain/usecases/create_task.dart';
import '../features/tasks/domain/usecases/update_task_status.dart';
import '../features/tasks/presentation/cubit/task_cubit.dart';
import '../features/tasks/domain/repositories/task_repository.dart';
import '../features/tasks/data/repositories/task_repository_impl.dart';
import '../features/tasks/data/datasources/task_remote_data_source.dart';

// Announcements Features
import '../features/announcements/domain/usecases/get_announcements.dart';
import '../features/announcements/domain/usecases/create_announcement.dart';
import '../features/announcements/presentation/cubit/announcement_cubit.dart';
import '../features/announcements/domain/repositories/announcement_repository.dart';
import '../features/announcements/data/repositories/announcement_repository_impl.dart';
import '../features/announcements/data/datasources/announcement_remote_data_source.dart';

// Calendar Features
import '../features/calendar/domain/usecases/get_events.dart';
import '../features/calendar/presentation/cubit/calendar_cubit.dart';
import '../features/calendar/domain/repositories/event_repository.dart';
import '../features/calendar/data/repositories/event_repository_impl.dart';
import '../features/calendar/data/datasources/event_remote_data_source.dart';

// Review Features
import '../features/reviews/domain/usecases/get_reviews.dart';
import '../features/reviews/domain/usecases/create_review.dart';
import '../features/reviews/presentation/cubit/review_cubit.dart';
import '../features/reviews/domain/repositories/review_repository.dart';
import '../features/reviews/data/repositories/review_repository_impl.dart';
import '../features/reviews/data/datasources/review_remote_data_source.dart';

// Expense Features
import '../features/expenses/domain/usecases/get_my_expenses.dart';
import '../features/expenses/domain/usecases/create_expense.dart';
import '../features/expenses/presentation/cubit/expense_cubit.dart';
import '../features/expenses/domain/repositories/expense_repository.dart';
import '../features/expenses/data/repositories/expense_repository_impl.dart';
import '../features/expenses/data/datasources/expense_remote_data_source.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // ApiClient
  sl.registerLazySingleton(() => ApiClient(baseUrl: 'https://api.example.com'));

  //! Features - Auth
  // Cubit
  sl.registerFactory(
    () => AuthCubit(
      loginUseCase: sl(),
      logoutUseCase: sl(),
      getCurrentUserUseCase: sl(),
    ),
  );

  // UseCases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton(() => MockAuthDataSource());
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );

  //! Features - Employees
  sl.registerFactory(
    () => EmployeesCubit(
      getEmployeesUseCase: sl(),
      addEmployeeUseCase: sl(),
      updateEmployeeUseCase: sl(),
    ),
  );

  // UseCases
  sl.registerLazySingleton(() => GetEmployeesUseCase(sl()));
  sl.registerLazySingleton(() => AddEmployeeUseCase(sl()));
  sl.registerLazySingleton(() => UpdateEmployeeUseCase(sl()));

  // Leaves
  sl.registerLazySingleton(() => GetLeavesUseCase(sl()));
  sl.registerLazySingleton(() => SubmitLeaveUseCase(sl()));
  sl.registerLazySingleton(() => ApproveLeaveUseCase(sl()));
  sl.registerLazySingleton(() => RejectLeaveUseCase(sl()));

  //! Features - Leaves Cubit
  sl.registerFactory(
    () => LeavesCubit(
      getLeavesUseCase: sl(),
      submitLeaveUseCase: sl(),
      approveLeaveUseCase: sl(),
      rejectLeaveUseCase: sl(),
    ),
  );

  // Attendance
  sl.registerLazySingleton(() => GetAttendanceUseCase(sl()));
  sl.registerLazySingleton(() => CheckInUseCase(sl()));
  sl.registerLazySingleton(() => CheckOutUseCase(sl()));

  sl.registerLazySingleton<EmployeeRepository>(
    () => EmployeeRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => MockEmployeeDataSource());

  //! Features - Attendance
  sl.registerFactory(
    () => AttendanceCubit(
      getAttendanceUseCase: sl(),
      checkInUseCase: sl(),
      checkOutUseCase: sl(),
    ),
  );
  sl.registerLazySingleton<AttendanceRepository>(
    () => AttendanceRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => MockAttendanceDataSource());

  //! Features - Leaves
  sl.registerLazySingleton<LeaveRepository>(() => LeaveRepositoryImpl(sl()));
  sl.registerLazySingleton(() => MockLeaveDataSource());

  //! Features - Payroll
  sl.registerLazySingleton<PayrollRepository>(
    () => PayrollRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => MockPayrollDataSource());

  //! Features - Bathroom
  sl.registerFactory(
    () => BathroomCubit(bathroomRepository: sl(), authRepository: sl()),
  );
  sl.registerLazySingleton<BathroomRepository>(
    () => BathroomRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => MockBathroomDataSource());

  //! Features - Dashboard
  sl.registerFactory(
    () => DashboardCubit(
      employeeRepository: sl(),
      attendanceRepository: sl(),
      leaveRepository: sl(),
      payrollRepository: sl(),
    ),
  );

  //! Features - Chat
  // Cubits
  sl.registerFactory(() => ChatListCubit(getChats: sl()));
  sl.registerFactory(
    () => ChatDetailCubit(getMessages: sl(), sendMessageUseCase: sl()),
  );

  // UseCases
  sl.registerLazySingleton(() => GetChats(sl()));
  sl.registerLazySingleton(() => GetMessages(sl()));
  sl.registerLazySingleton(() => SendMessage(sl()));

  // Repository
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(),
  );

  //! Features - Tasks
  // Cubit
  sl.registerFactory(
    () => TaskCubit(getTasks: sl(), createTask: sl(), updateTaskStatus: sl()),
  );

  // UseCases
  sl.registerLazySingleton(() => GetTasks(sl()));
  sl.registerLazySingleton(() => CreateTask(sl()));
  sl.registerLazySingleton(() => UpdateTaskStatus(sl()));

  // Repository
  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<TaskRemoteDataSource>(
    () => TaskRemoteDataSourceImpl(),
  );

  //! Features - Announcements
  // Cubit
  sl.registerFactory(
    () => AnnouncementCubit(getAnnouncements: sl(), createAnnouncement: sl()),
  );

  // UseCases
  sl.registerLazySingleton(() => GetAnnouncements(sl()));
  sl.registerLazySingleton(() => CreateAnnouncement(sl()));

  // Repository
  sl.registerLazySingleton<AnnouncementRepository>(
    () => AnnouncementRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<AnnouncementRemoteDataSource>(
    () => AnnouncementRemoteDataSourceImpl(),
  );

  //! Features - Calendar
  // Cubit
  sl.registerFactory(() => CalendarCubit(getEvents: sl()));

  // UseCases
  sl.registerLazySingleton(() => GetEvents(sl()));

  // Repository
  sl.registerLazySingleton<EventRepository>(
    () => EventRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<EventRemoteDataSource>(
    () => EventRemoteDataSourceImpl(),
  );

  //! Features - Reviews
  // Cubit
  sl.registerFactory(() => ReviewCubit(getReviews: sl(), createReview: sl()));

  // UseCases
  sl.registerLazySingleton(() => GetReviews(sl()));
  sl.registerLazySingleton(() => CreateReview(sl()));

  // Repository
  sl.registerLazySingleton<ReviewRepository>(
    () => ReviewRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<ReviewRemoteDataSource>(
    () => ReviewRemoteDataSourceImpl(),
  );

  //! Features - Expenses
  // Cubit
  sl.registerFactory(
    () => ExpenseCubit(getMyExpenses: sl(), createExpense: sl()),
  );

  // UseCases
  sl.registerLazySingleton(() => GetMyExpenses(sl()));
  sl.registerLazySingleton(() => CreateExpense(sl()));

  // Repository
  sl.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<ExpenseRemoteDataSource>(
    () => ExpenseRemoteDataSourceImpl(),
  );
}
