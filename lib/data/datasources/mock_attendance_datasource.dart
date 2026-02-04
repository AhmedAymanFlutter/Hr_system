import '../models/attendance_model.dart';

class MockAttendanceDataSource {
  // Simulate network delay
  Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  // Generate mock attendance data for the current month
  List<AttendanceModel> _generateMockAttendance() {
    final now = DateTime.now();
    final List<AttendanceModel> attendance = [];

    // Generate attendance for the past 30 days
    for (int i = 0; i < 30; i++) {
      final date = now.subtract(Duration(days: i));

      // Skip weekends
      if (date.weekday == DateTime.saturday ||
          date.weekday == DateTime.sunday) {
        continue;
      }

      // Employee 1
      attendance.add(
        AttendanceModel(
          id: 'att_${date.millisecondsSinceEpoch}_1',
          employeeId: '1',
          employeeName: 'John Doe',
          date: date,
          checkIn: DateTime(date.year, date.month, date.day, 9, 0),
          checkOut: DateTime(date.year, date.month, date.day, 17, 30),
          status: AttendanceStatus.present,
          workDuration: const Duration(hours: 8, minutes: 30),
        ),
      );

      // Employee 2
      attendance.add(
        AttendanceModel(
          id: 'att_${date.millisecondsSinceEpoch}_2',
          employeeId: '2',
          employeeName: 'Sarah Johnson',
          date: date,
          checkIn: DateTime(date.year, date.month, date.day, 8, 45),
          checkOut: DateTime(date.year, date.month, date.day, 17, 15),
          status: AttendanceStatus.present,
          workDuration: const Duration(hours: 8, minutes: 30),
        ),
      );

      // Employee 3 - occasionally late
      attendance.add(
        AttendanceModel(
          id: 'att_${date.millisecondsSinceEpoch}_3',
          employeeId: '3',
          employeeName: 'Michael Chen',
          date: date,
          checkIn: DateTime(
            date.year,
            date.month,
            date.day,
            i % 5 == 0 ? 10 : 9,
            0,
          ),
          checkOut: DateTime(date.year, date.month, date.day, 18, 0),
          status: i % 5 == 0 ? AttendanceStatus.late : AttendanceStatus.present,
          workDuration: Duration(hours: i % 5 == 0 ? 8 : 9),
        ),
      );

      // Employee 4
      attendance.add(
        AttendanceModel(
          id: 'att_${date.millisecondsSinceEpoch}_4',
          employeeId: '4',
          employeeName: 'Emily Williams',
          date: date,
          checkIn: DateTime(date.year, date.month, date.day, 9, 15),
          checkOut: DateTime(date.year, date.month, date.day, 17, 45),
          status: AttendanceStatus.present,
          workDuration: const Duration(hours: 8, minutes: 30),
        ),
      );

      // Employee 5
      attendance.add(
        AttendanceModel(
          id: 'att_${date.millisecondsSinceEpoch}_5',
          employeeId: '5',
          employeeName: 'David Brown',
          date: date,
          checkIn: DateTime(date.year, date.month, date.day, 9, 0),
          checkOut: DateTime(date.year, date.month, date.day, 18, 30),
          status: AttendanceStatus.present,
          workDuration: const Duration(hours: 9, minutes: 30),
        ),
      );
    }

    return attendance;
  }

  late final List<AttendanceModel> _mockAttendance = _generateMockAttendance();

  Future<List<AttendanceModel>> getAttendanceByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    await _simulateDelay();
    return _mockAttendance.where((a) {
      return a.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
          a.date.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }

  Future<List<AttendanceModel>> getAttendanceByEmployee(
    String employeeId,
  ) async {
    await _simulateDelay();
    return _mockAttendance.where((a) => a.employeeId == employeeId).toList();
  }

  Future<List<AttendanceModel>> getTodayAttendance() async {
    await _simulateDelay();
    final today = DateTime.now();
    return _mockAttendance.where((a) {
      return a.date.year == today.year &&
          a.date.month == today.month &&
          a.date.day == today.day;
    }).toList();
  }

  Future<AttendanceModel> checkIn(
    String employeeId,
    String employeeName,
  ) async {
    await _simulateDelay();
    final now = DateTime.now();
    final attendance = AttendanceModel(
      id: 'att_${now.millisecondsSinceEpoch}',
      employeeId: employeeId,
      employeeName: employeeName,
      date: now,
      checkIn: now,
      status: now.hour <= 9 ? AttendanceStatus.present : AttendanceStatus.late,
    );
    _mockAttendance.add(attendance);
    return attendance;
  }

  Future<AttendanceModel> checkOut(String attendanceId) async {
    await _simulateDelay();
    final index = _mockAttendance.indexWhere((a) => a.id == attendanceId);
    if (index == -1) {
      throw Exception('Attendance record not found');
    }

    final now = DateTime.now();
    final attendance = _mockAttendance[index];
    final duration = attendance.checkIn != null
        ? now.difference(attendance.checkIn!)
        : null;

    final updated = attendance.copyWith(checkOut: now, workDuration: duration);
    _mockAttendance[index] = updated;
    return updated;
  }

  Future<Map<String, int>> getAttendanceStats() async {
    await _simulateDelay();
    final today = DateTime.now();
    final todayAttendance = _mockAttendance.where((a) {
      return a.date.year == today.year &&
          a.date.month == today.month &&
          a.date.day == today.day;
    }).toList();

    return {
      'present': todayAttendance
          .where((a) => a.status == AttendanceStatus.present)
          .length,
      'late': todayAttendance
          .where((a) => a.status == AttendanceStatus.late)
          .length,
      'absent': todayAttendance
          .where((a) => a.status == AttendanceStatus.absent)
          .length,
    };
  }
}
