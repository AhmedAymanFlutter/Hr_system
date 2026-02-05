import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../domain/repositories/leave_repository.dart';
import '../../../../data/models/leave_model.dart';

class GetLeavesParams extends Equatable {
  final String? employeeId;
  final LeaveStatus? status;
  final bool isPendingOnly;

  const GetLeavesParams({
    this.employeeId,
    this.status,
    this.isPendingOnly = false,
  });

  @override
  List<Object?> get props => [employeeId, status, isPendingOnly];
}

class GetLeavesUseCase extends BaseUseCase<List<LeaveModel>, GetLeavesParams> {
  final LeaveRepository repository;

  GetLeavesUseCase(this.repository);

  @override
  Future<Result<List<LeaveModel>, Failure>> call(GetLeavesParams params) async {
    try {
      if (params.isPendingOnly) {
        final result = await repository.getPendingLeaves();
        return Success(result);
      } else if (params.employeeId != null) {
        final result = await repository.getLeavesByEmployee(params.employeeId!);
        return Success(result);
      } else if (params.status != null) {
        final result = await repository.getLeavesByStatus(params.status!);
        return Success(result);
      } else {
        final result = await repository.getAllLeaves();
        return Success(result);
      }
    } catch (e) {
      return Error(ServerFailure(e.toString()));
    }
  }
}
