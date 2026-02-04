import '../../domain/repositories/leave_repository.dart';
import '../datasources/mock_leave_datasource.dart';
import '../models/leave_model.dart';

class LeaveRepositoryImpl implements LeaveRepository {
  final MockLeaveDataSource dataSource;

  LeaveRepositoryImpl(this.dataSource);

  @override
  Future<List<LeaveModel>> getAllLeaves() async {
    try {
      return await dataSource.getAllLeaves();
    } catch (e) {
      throw Exception('Failed to get leaves: ${e.toString()}');
    }
  }

  @override
  Future<List<LeaveModel>> getLeavesByEmployee(String employeeId) async {
    try {
      return await dataSource.getLeavesByEmployee(employeeId);
    } catch (e) {
      throw Exception('Failed to get employee leaves: ${e.toString()}');
    }
  }

  @override
  Future<List<LeaveModel>> getLeavesByStatus(LeaveStatus status) async {
    try {
      return await dataSource.getLeavesByStatus(status);
    } catch (e) {
      throw Exception('Failed to get leaves by status: ${e.toString()}');
    }
  }

  @override
  Future<List<LeaveModel>> getPendingLeaves() async {
    try {
      return await dataSource.getPendingLeaves();
    } catch (e) {
      throw Exception('Failed to get pending leaves: ${e.toString()}');
    }
  }

  @override
  Future<LeaveModel> submitLeaveRequest(LeaveModel leave) async {
    try {
      return await dataSource.submitLeaveRequest(leave);
    } catch (e) {
      throw Exception('Failed to submit leave request: ${e.toString()}');
    }
  }

  @override
  Future<LeaveModel> approveLeave(String leaveId, String approvedBy) async {
    try {
      return await dataSource.approveLeave(leaveId, approvedBy);
    } catch (e) {
      throw Exception('Failed to approve leave: ${e.toString()}');
    }
  }

  @override
  Future<LeaveModel> rejectLeave(String leaveId, String rejectionReason) async {
    try {
      return await dataSource.rejectLeave(leaveId, rejectionReason);
    } catch (e) {
      throw Exception('Failed to reject leave: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, int>> getLeaveStats() async {
    try {
      return await dataSource.getLeaveStats();
    } catch (e) {
      throw Exception('Failed to get leave stats: ${e.toString()}');
    }
  }
}
