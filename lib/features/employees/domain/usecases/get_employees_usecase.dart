import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../domain/repositories/employee_repository.dart';
import '../../../../data/models/employee_model.dart';

class GetEmployeesUseCase extends BaseUseCase<List<EmployeeModel>, NoParams> {
  final EmployeeRepository repository;

  GetEmployeesUseCase(this.repository);

  @override
  Future<Result<List<EmployeeModel>, Failure>> call(NoParams params) async {
    try {
      final employees = await repository.getAllEmployees();
      return Success(employees);
    } catch (e) {
      return Error(ServerFailure(e.toString()));
    }
  }
}
