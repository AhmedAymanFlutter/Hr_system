import 'package:equatable/equatable.dart';
import '../../../../data/models/leave_model.dart';

abstract class LeavesState extends Equatable {
  const LeavesState();
  @override
  List<Object> get props => [];
}

class LeavesInitial extends LeavesState {
  const LeavesInitial();
}

class LeavesLoading extends LeavesState {
  const LeavesLoading();
}

class LeavesLoaded extends LeavesState {
  final List<LeaveModel> leaves;
  // Can add separate list for filter results or maintain allLeaves vs filteredLeaves
  const LeavesLoaded(this.leaves);
  @override
  List<Object> get props => [leaves];
}

class LeavesError extends LeavesState {
  final String message;
  const LeavesError(this.message);
  @override
  List<Object> get props => [message];
}
