import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/models/employee_model.dart';
import '../../../../domain/repositories/employee_repository.dart';
import 'employees_state.dart';

class EmployeesCubit extends Cubit<EmployeesState> {
  final EmployeeRepository repository;
  List<EmployeeModel> _allEmployees = [];

  EmployeesCubit(this.repository) : super(const EmployeesInitial());

  Future<void> loadEmployees() async {
    emit(const EmployeesLoading());

    try {
      _allEmployees = await repository.getAllEmployees();
      emit(EmployeesLoaded(_allEmployees));
    } catch (e) {
      emit(EmployeesError(e.toString()));
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
