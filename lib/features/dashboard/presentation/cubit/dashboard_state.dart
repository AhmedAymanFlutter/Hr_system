import 'package:equatable/equatable.dart';

class DashboardStats {
  final int totalEmployees;
  final int presentToday;
  final int pendingLeaves;
  final double monthlyPayroll;

  const DashboardStats({
    required this.totalEmployees,
    required this.presentToday,
    required this.pendingLeaves,
    required this.monthlyPayroll,
    this.assignedTasks = const [],
    this.isCheckedIn = false,
  });

  final List<dynamic>
  assignedTasks; // Using dynamic for now to avoid circular import issues, will fix cleanly.
  final bool isCheckedIn;
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
