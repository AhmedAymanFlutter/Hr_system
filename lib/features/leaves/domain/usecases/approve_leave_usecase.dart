import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../domain/repositories/leave_repository.dart';

class ApproveLeaveParams {
  final String leaveId;
  final String approvedBy;
  const ApproveLeaveParams({required this.leaveId, required this.approvedBy});
}

class ApproveLeaveUseCase extends BaseUseCase<void, ApproveLeaveParams> {
  final LeaveRepository repository;

  ApproveLeaveUseCase(this.repository);

  @override
  Future<Result<void, Failure>> call(ApproveLeaveParams params) async {
    try {
      await repository.approveLeave(params.leaveId, params.approvedBy);
      return const Success(null);
    } catch (e) {
      return Error(ServerFailure(e.toString()));
    }
  }
}
