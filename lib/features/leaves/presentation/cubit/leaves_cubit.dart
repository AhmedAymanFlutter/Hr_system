import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../data/models/leave_model.dart';
import '../../domain/usecases/get_leaves_usecase.dart';
import '../../domain/usecases/submit_leave_usecase.dart';
import '../../domain/usecases/approve_leave_usecase.dart';
import 'leaves_state.dart';

class LeavesCubit extends Cubit<LeavesState> {
  final GetLeavesUseCase getLeavesUseCase;
  final SubmitLeaveUseCase submitLeaveUseCase;
  final ApproveLeaveUseCase approveLeaveUseCase;

  LeavesCubit({
    required this.getLeavesUseCase,
    required this.submitLeaveUseCase,
    required this.approveLeaveUseCase,
  }) : super(const LeavesInitial());

  Future<void> loadLeaves({
    String? employeeId,
    bool isPendingOnly = false,
  }) async {
    emit(const LeavesLoading());
    final result = await getLeavesUseCase(
      GetLeavesParams(employeeId: employeeId, isPendingOnly: isPendingOnly),
    );

    if (result is Success<List<LeaveModel>, dynamic>) {
      emit(LeavesLoaded((result as Success<List<LeaveModel>, dynamic>).value));
    } else if (result is Error) {
      final failure = (result as Error).failure;
      emit(LeavesError(failure.message));
    }
  }

  Future<void> submitLeave(LeaveModel leave) async {
    emit(const LeavesLoading());
    final result = await submitLeaveUseCase(leave);
    if (result is Success) {
      loadLeaves(); // Reload all default
    } else {
      final failure = (result as Error).failure;
      emit(LeavesError(failure.message));
    }
  }

  Future<void> approveLeave(String leaveId, String adminId) async {
    emit(const LeavesLoading());
    final result = await approveLeaveUseCase(
      ApproveLeaveParams(leaveId: leaveId, approvedBy: adminId),
    );
    if (result is Success) {
      loadLeaves(isPendingOnly: true); // Reload pending
    } else {
      final failure = (result as Error).failure;
      emit(LeavesError(failure.message));
    }
  }
}
