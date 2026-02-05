import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../domain/repositories/leave_repository.dart';
import '../../../../data/models/leave_model.dart';

class SubmitLeaveUseCase extends BaseUseCase<void, LeaveModel> {
  final LeaveRepository repository;

  SubmitLeaveUseCase(this.repository);

  @override
  Future<Result<void, Failure>> call(LeaveModel params) async {
    try {
      await repository.submitLeaveRequest(params);
      return const Success(null);
    } catch (e) {
      return Error(ServerFailure(e.toString()));
    }
  }
}
