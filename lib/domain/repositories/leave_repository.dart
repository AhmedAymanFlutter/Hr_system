import '../../data/models/leave_model.dart';

abstract class LeaveRepository {
  Future<List<LeaveModel>> getAllLeaves();
  Future<List<LeaveModel>> getLeavesByEmployee(String employeeId);
  Future<List<LeaveModel>> getLeavesByStatus(LeaveStatus status);
  Future<List<LeaveModel>> getPendingLeaves();
  Future<LeaveModel> submitLeaveRequest(LeaveModel leave);
  Future<LeaveModel> approveLeave(String leaveId, String approvedBy);
  Future<LeaveModel> rejectLeave(String leaveId, String rejectionReason);
  Future<Map<String, int>> getLeaveStats();
}
