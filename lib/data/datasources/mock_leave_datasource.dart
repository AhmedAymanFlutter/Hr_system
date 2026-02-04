import '../models/leave_model.dart';

class MockLeaveDataSource {
  // Simulate network delay
  Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  // Mock leave requests database
  final List<LeaveModel> _mockLeaves = [
    LeaveModel(
      id: '1',
      employeeId: '1',
      employeeName: 'John Doe',
      type: LeaveType.annual,
      startDate: DateTime.now().add(const Duration(days: 10)),
      endDate: DateTime.now().add(const Duration(days: 15)),
      daysCount: 5,
      reason: 'Family vacation',
      status: LeaveStatus.pending,
      requestDate: DateTime.now().subtract(const Duration(days: 2)),
    ),
    LeaveModel(
      id: '2',
      employeeId: '3',
      employeeName: 'Michael Chen',
      type: LeaveType.sick,
      startDate: DateTime.now().subtract(const Duration(days: 3)),
      endDate: DateTime.now().subtract(const Duration(days: 1)),
      daysCount: 2,
      reason: 'Medical appointment',
      status: LeaveStatus.approved,
      requestDate: DateTime.now().subtract(const Duration(days: 5)),
      approvedBy: 'Sarah Johnson',
      approvalDate: DateTime.now().subtract(const Duration(days: 4)),
    ),
    LeaveModel(
      id: '3',
      employeeId: '4',
      employeeName: 'Emily Williams',
      type: LeaveType.casual,
      startDate: DateTime.now().add(const Duration(days: 5)),
      endDate: DateTime.now().add(const Duration(days: 6)),
      daysCount: 2,
      reason: 'Personal matters',
      status: LeaveStatus.pending,
      requestDate: DateTime.now().subtract(const Duration(days: 1)),
    ),
    LeaveModel(
      id: '4',
      employeeId: '5',
      employeeName: 'David Brown',
      type: LeaveType.annual,
      startDate: DateTime.now().subtract(const Duration(days: 10)),
      endDate: DateTime.now().subtract(const Duration(days: 5)),
      daysCount: 5,
      reason: 'Holiday trip',
      status: LeaveStatus.approved,
      requestDate: DateTime.now().subtract(const Duration(days: 15)),
      approvedBy: 'Sarah Johnson',
      approvalDate: DateTime.now().subtract(const Duration(days: 12)),
    ),
    LeaveModel(
      id: '5',
      employeeId: '6',
      employeeName: 'Lisa Anderson',
      type: LeaveType.sick,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 7)),
      daysCount: 7,
      reason: 'Medical recovery',
      status: LeaveStatus.approved,
      requestDate: DateTime.now().subtract(const Duration(days: 1)),
      approvedBy: 'Sarah Johnson',
      approvalDate: DateTime.now(),
    ),
    LeaveModel(
      id: '6',
      employeeId: '1',
      employeeName: 'John Doe',
      type: LeaveType.casual,
      startDate: DateTime.now().subtract(const Duration(days: 20)),
      endDate: DateTime.now().subtract(const Duration(days: 20)),
      daysCount: 1,
      reason: 'Personal emergency',
      status: LeaveStatus.rejected,
      requestDate: DateTime.now().subtract(const Duration(days: 21)),
      rejectionReason: 'Too many pending requests',
      approvalDate: DateTime.now().subtract(const Duration(days: 20)),
    ),
  ];

  Future<List<LeaveModel>> getAllLeaves() async {
    await _simulateDelay();
    return List.from(_mockLeaves);
  }

  Future<List<LeaveModel>> getLeavesByEmployee(String employeeId) async {
    await _simulateDelay();
    return _mockLeaves.where((l) => l.employeeId == employeeId).toList();
  }

  Future<List<LeaveModel>> getLeavesByStatus(LeaveStatus status) async {
    await _simulateDelay();
    return _mockLeaves.where((l) => l.status == status).toList();
  }

  Future<List<LeaveModel>> getPendingLeaves() async {
    await _simulateDelay();
    return _mockLeaves.where((l) => l.status == LeaveStatus.pending).toList();
  }

  Future<LeaveModel> submitLeaveRequest(LeaveModel leave) async {
    await _simulateDelay();
    final newLeave = leave.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      status: LeaveStatus.pending,
      requestDate: DateTime.now(),
    );
    _mockLeaves.add(newLeave);
    return newLeave;
  }

  Future<LeaveModel> approveLeave(String leaveId, String approvedBy) async {
    await _simulateDelay();
    final index = _mockLeaves.indexWhere((l) => l.id == leaveId);
    if (index == -1) {
      throw Exception('Leave request not found');
    }

    final updated = _mockLeaves[index].copyWith(
      status: LeaveStatus.approved,
      approvedBy: approvedBy,
      approvalDate: DateTime.now(),
    );
    _mockLeaves[index] = updated;
    return updated;
  }

  Future<LeaveModel> rejectLeave(String leaveId, String rejectionReason) async {
    await _simulateDelay();
    final index = _mockLeaves.indexWhere((l) => l.id == leaveId);
    if (index == -1) {
      throw Exception('Leave request not found');
    }

    final updated = _mockLeaves[index].copyWith(
      status: LeaveStatus.rejected,
      rejectionReason: rejectionReason,
      approvalDate: DateTime.now(),
    );
    _mockLeaves[index] = updated;
    return updated;
  }

  Future<Map<String, int>> getLeaveStats() async {
    await _simulateDelay();
    return {
      'pending': _mockLeaves
          .where((l) => l.status == LeaveStatus.pending)
          .length,
      'approved': _mockLeaves
          .where((l) => l.status == LeaveStatus.approved)
          .length,
      'rejected': _mockLeaves
          .where((l) => l.status == LeaveStatus.rejected)
          .length,
    };
  }
}
