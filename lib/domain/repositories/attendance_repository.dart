import '../../data/models/attendance_model.dart';

abstract class AttendanceRepository {
  Future<List<AttendanceModel>> getAttendanceByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  });
  Future<List<AttendanceModel>> getAttendanceByEmployee(String employeeId);
  Future<List<AttendanceModel>> getTodayAttendance();
  Future<AttendanceModel> checkIn(String employeeId, String employeeName);
  Future<AttendanceModel> checkOut(String attendanceId);
  Future<Map<String, int>> getAttendanceStats();
}
