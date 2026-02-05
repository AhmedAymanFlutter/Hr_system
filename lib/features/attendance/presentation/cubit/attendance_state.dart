import 'package:equatable/equatable.dart';
import '../../../../data/models/attendance_model.dart';

abstract class AttendanceState extends Equatable {
  const AttendanceState();

  @override
  List<Object?> get props => [];
}

class AttendanceInitial extends AttendanceState {
  const AttendanceInitial();
}

class AttendanceLoading extends AttendanceState {
  const AttendanceLoading();
}

class AttendanceLoaded extends AttendanceState {
  final List<AttendanceModel> attendanceList;
  final AttendanceModel? currentUserAttendance; // For employee view

  const AttendanceLoaded(this.attendanceList, {this.currentUserAttendance});

  @override
  List<Object?> get props => [attendanceList, currentUserAttendance];
}

class AttendanceError extends AttendanceState {
  final String message;
  const AttendanceError(this.message);

  @override
  List<Object> get props => [message];
}
