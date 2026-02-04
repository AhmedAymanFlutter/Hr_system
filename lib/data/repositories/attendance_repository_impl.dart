import '../../domain/repositories/attendance_repository.dart';
import '../datasources/mock_attendance_datasource.dart';
import '../models/attendance_model.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final MockAttendanceDataSource dataSource;

  AttendanceRepositoryImpl(this.dataSource);

  @override
  Future<List<AttendanceModel>> getAttendanceByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      return await dataSource.getAttendanceByDateRange(
        startDate: startDate,
        endDate: endDate,
      );
    } catch (e) {
      throw Exception('Failed to get attendance: ${e.toString()}');
    }
  }

  @override
  Future<List<AttendanceModel>> getAttendanceByEmployee(
    String employeeId,
  ) async {
    try {
      return await dataSource.getAttendanceByEmployee(employeeId);
    } catch (e) {
      throw Exception('Failed to get employee attendance: ${e.toString()}');
    }
  }

  @override
  Future<List<AttendanceModel>> getTodayAttendance() async {
    try {
      return await dataSource.getTodayAttendance();
    } catch (e) {
      throw Exception('Failed to get today attendance: ${e.toString()}');
    }
  }

  @override
  Future<AttendanceModel> checkIn(
    String employeeId,
    String employeeName,
  ) async {
    try {
      return await dataSource.checkIn(employeeId, employeeName);
    } catch (e) {
      throw Exception('Failed to check in: ${e.toString()}');
    }
  }

  @override
  Future<AttendanceModel> checkOut(String attendanceId) async {
    try {
      return await dataSource.checkOut(attendanceId);
    } catch (e) {
      throw Exception('Failed to check out: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, int>> getAttendanceStats() async {
    try {
      return await dataSource.getAttendanceStats();
    } catch (e) {
      throw Exception('Failed to get attendance stats: ${e.toString()}');
    }
  }
}
