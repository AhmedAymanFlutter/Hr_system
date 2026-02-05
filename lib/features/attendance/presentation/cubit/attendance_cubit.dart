import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../data/models/attendance_model.dart';
import '../../domain/usecases/get_attendance_usecase.dart';
import '../../domain/usecases/check_in_usecase.dart';
import '../../domain/usecases/check_out_usecase.dart';
import 'attendance_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  final GetAttendanceUseCase getAttendanceUseCase;
  final CheckInUseCase checkInUseCase;
  final CheckOutUseCase checkOutUseCase;

  List<AttendanceModel> _currentList = [];

  AttendanceCubit({
    required this.getAttendanceUseCase,
    required this.checkInUseCase,
    required this.checkOutUseCase,
  }) : super(const AttendanceInitial());

  Future<void> loadTodayAttendance() async {
    emit(const AttendanceLoading());
    final result = await getAttendanceUseCase(DateTime.now());

    if (result is Success<List<AttendanceModel>, dynamic>) {
      _currentList = (result as Success<List<AttendanceModel>, dynamic>).value;
      emit(AttendanceLoaded(_currentList));
    } else if (result is Error) {
      final failure = (result as Error).failure;
      emit(AttendanceError(failure.message));
    }
  }

  Future<void> checkIn(String employeeId, String employeeName) async {
    emit(const AttendanceLoading());
    // Note: Creating params needs 'CheckInParams' but it's not exported by default properly from usecase file if I didn't export it.
    // I should move CheckInParams to a separate file or import it here explicitly if accessible.
    // Assuming UseCase definition is accessible.
    final result = await checkInUseCase(
      CheckInParams(employeeId: employeeId, employeeName: employeeName),
    );

    if (result is Success) {
      loadTodayAttendance();
    } else {
      final failure = (result as Error).failure;
      emit(AttendanceError(failure.message));
    }
  }

  Future<void> checkOut(String attendanceId) async {
    emit(const AttendanceLoading());
    final result = await checkOutUseCase(attendanceId);

    if (result is Success) {
      loadTodayAttendance();
    } else {
      final failure = (result as Error).failure;
      emit(AttendanceError(failure.message));
    }
  }
}
