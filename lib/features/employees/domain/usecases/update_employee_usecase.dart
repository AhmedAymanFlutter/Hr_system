import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../domain/repositories/employee_repository.dart';
import '../../../../data/models/employee_model.dart'; // Add this import

class UpdateEmployeeUseCase extends BaseUseCase<void, EmployeeModel> {
  final EmployeeRepository repository;

  UpdateEmployeeUseCase(this.repository);

  @override
  Future<Result<void, Failure>> call(EmployeeModel params) async {
    try {
      await repository.updateEmployee(params);
      return const Success(null);
    } catch (e) {
      return Error(ServerFailure(e.toString()));
    }
  }
}
