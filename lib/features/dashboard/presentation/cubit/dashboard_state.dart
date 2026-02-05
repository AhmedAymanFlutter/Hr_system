import 'package:equatable/equatable.dart';
import '../../data/models/task_model.dart';

class DashboardStats {
  final int totalEmployees;
  final int presentToday;
  final int pendingLeaves;
  final double monthlyPayroll;

  /* final List<dynamic> assignedTasks; */ // Removed hack
  final List<TaskModel> assignedTasks;
  final bool isCheckedIn;
  final List<ActivityLog> recentActivity;
  final Map<String, double> trends;

  const DashboardStats({
    required this.totalEmployees,
    required this.presentToday,
    required this.pendingLeaves,
    required this.monthlyPayroll,
    this.assignedTasks = const [],
    this.isCheckedIn = false,
    this.recentActivity = const [],
    this.trends = const {},
  });
}

class ActivityLog {
  final String id;
  final String title;
  final String subtitle;
  final DateTime timestamp;
  final String type;

  const ActivityLog({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.type,
  });
}

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardState {
  final DashboardStats stats;

  const DashboardLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
