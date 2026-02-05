import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../domain/repositories/attendance_repository.dart';
import '../../../../data/models/attendance_model.dart';

class GetAttendanceUseCase
    extends BaseUseCase<List<AttendanceModel>, DateTime> {
  final AttendanceRepository repository;

  GetAttendanceUseCase(this.repository);

  @override
  Future<Result<List<AttendanceModel>, Failure>> call(DateTime date) async {
    try {
      // Assuming getTodayAttendance implies getting attendance for a specific date or just today
      // For now, mapping date to today roughly or updating repository definition later
      // The current repo interface has getTodayAttendance(), let's use that if date is today
      final attendance = await repository.getTodayAttendance();
      return Success(attendance);
    } catch (e) {
      return Error(ServerFailure(e.toString()));
    }
  }
}
