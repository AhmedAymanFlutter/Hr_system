import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../../data/models/employee_model.dart';
import '../../domain/usecases/add_employee_usecase.dart';
import '../../domain/usecases/get_employees_usecase.dart';
import '../../domain/usecases/update_employee_usecase.dart';
import 'employees_state.dart';

class EmployeesCubit extends Cubit<EmployeesState> {
  final GetEmployeesUseCase getEmployeesUseCase;
  final AddEmployeeUseCase addEmployeeUseCase;
  final UpdateEmployeeUseCase updateEmployeeUseCase;

  List<EmployeeModel> _allEmployees = [];

  EmployeesCubit({
    required this.getEmployeesUseCase,
    required this.addEmployeeUseCase,
    required this.updateEmployeeUseCase,
  }) : super(const EmployeesInitial());

  Future<void> loadEmployees() async {
    emit(const EmployeesLoading());

    final result = await getEmployeesUseCase(NoParams());

    if (result is Success<List<EmployeeModel>, dynamic>) {
      _allEmployees = (result as Success<List<EmployeeModel>, dynamic>).value;
      emit(EmployeesLoaded(_allEmployees));
    } else if (result is Error) {
      // Accessing generic error
      final failure = (result as Error).failure;
      emit(
        EmployeesError(failure.message),
      ); // Assuming Failure has message or toString
    }
  }

  Future<void> addEmployee(EmployeeModel employee) async {
    emit(const EmployeesLoading());
    final result = await addEmployeeUseCase(employee);

    if (result is Success) {
      loadEmployees(); // Reload to get potential new data or just append
    } else {
      emit(EmployeesError('Failed to add employee'));
    }
  }

  Future<void> updateEmployee(EmployeeModel employee) async {
    emit(const EmployeesLoading());
    final result = await updateEmployeeUseCase(employee);

    if (result is Success) {
      loadEmployees();
    } else {
      emit(EmployeesError('Failed to update employee'));
    }
  }

  void searchEmployees(String query) {
    if (query.isEmpty) {
      emit(EmployeesLoaded(_allEmployees));
    } else {
      final filtered = _allEmployees.where((employee) {
        return employee.name.toLowerCase().contains(query.toLowerCase()) ||
            employee.email.toLowerCase().contains(query.toLowerCase()) ||
            employee.department.toLowerCase().contains(query.toLowerCase());
      }).toList();
      emit(EmployeesLoaded(filtered, searchQuery: query));
    }
  }

  void refresh() {
    loadEmployees();
  }
}
