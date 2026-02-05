import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../domain/repositories/attendance_repository.dart';

class CheckOutUseCase extends BaseUseCase<void, String> {
  final AttendanceRepository repository;

  CheckOutUseCase(this.repository);

  @override
  Future<Result<void, Failure>> call(String attendanceId) async {
    try {
      await repository.checkOut(attendanceId);
      return const Success(null);
    } catch (e) {
      return Error(ServerFailure(e.toString()));
    }
  }
}
