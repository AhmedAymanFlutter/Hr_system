import 'package:equatable/equatable.dart';
import '../../../../data/models/employee_model.dart';

abstract class EmployeesState extends Equatable {
  const EmployeesState();

  @override
  List<Object?> get props => [];
}

class EmployeesInitial extends EmployeesState {
  const EmployeesInitial();
}

class EmployeesLoading extends EmployeesState {
  const EmployeesLoading();
}

class EmployeesLoaded extends EmployeesState {
  final List<EmployeeModel> employees;
  final String? searchQuery;

  const EmployeesLoaded(this.employees, {this.searchQuery});

  @override
  List<Object?> get props => [employees, searchQuery];
}

class EmployeesError extends EmployeesState {
  final String message;

  const EmployeesError(this.message);

  @override
  List<Object?> get props => [message];
}
