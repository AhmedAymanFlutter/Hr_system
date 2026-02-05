import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../domain/repositories/attendance_repository.dart';

class CheckInParams {
  final String employeeId;
  final String employeeName;
  const CheckInParams({required this.employeeId, required this.employeeName});
}

class CheckInUseCase extends BaseUseCase<void, CheckInParams> {
  final AttendanceRepository repository;

  CheckInUseCase(this.repository);

  @override
  Future<Result<void, Failure>> call(CheckInParams params) async {
    try {
      await repository.checkIn(params.employeeId, params.employeeName);
      return const Success(null);
    } catch (e) {
      return Error(ServerFailure(e.toString()));
    }
  }
}
