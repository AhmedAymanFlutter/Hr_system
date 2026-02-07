import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../domain/repositories/leave_repository.dart';

class RejectLeaveParams {
  final String leaveId;
  final String rejectionReason;
  const RejectLeaveParams({
    required this.leaveId,
    required this.rejectionReason,
  });
}

class RejectLeaveUseCase extends BaseUseCase<void, RejectLeaveParams> {
  final LeaveRepository repository;

  RejectLeaveUseCase(this.repository);

  @override
  Future<Result<void, Failure>> call(RejectLeaveParams params) async {
    try {
      await repository.rejectLeave(params.leaveId, params.rejectionReason);
      return const Success(null);
    } catch (e) {
      return Error(ServerFailure(e.toString()));
    }
  }
}
