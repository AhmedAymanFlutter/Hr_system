import 'package:equatable/equatable.dart';

enum LeaveType { sick, casual, annual, unpaid, emergency }

enum LeaveStatus { pending, approved, rejected, cancelled }

class LeaveModel extends Equatable {
  final String id;
  final String employeeId;
  final String employeeName;
  final LeaveType type;
  final DateTime startDate;
  final DateTime endDate;
  final int daysCount;
  final String reason;
  final LeaveStatus status;
  final String? rejectionReason;
  final DateTime requestDate;
  final String? approvedBy;
  final DateTime? approvalDate;

  const LeaveModel({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.daysCount,
    required this.reason,
    required this.status,
    this.rejectionReason,
    required this.requestDate,
    this.approvedBy,
    this.approvalDate,
  });

  factory LeaveModel.fromJson(Map<String, dynamic> json) {
    return LeaveModel(
      id: json['id'] as String,
      employeeId: json['employeeId'] as String,
      employeeName: json['employeeName'] as String,
      type: LeaveType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => LeaveType.casual,
      ),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      daysCount: json['daysCount'] as int,
      reason: json['reason'] as String,
      status: LeaveStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => LeaveStatus.pending,
      ),
      rejectionReason: json['rejectionReason'] as String?,
      requestDate: DateTime.parse(json['requestDate'] as String),
      approvedBy: json['approvedBy'] as String?,
      approvalDate: json['approvalDate'] != null
          ? DateTime.parse(json['approvalDate'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'employeeName': employeeName,
      'type': type.name,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'daysCount': daysCount,
      'reason': reason,
      'status': status.name,
      'rejectionReason': rejectionReason,
      'requestDate': requestDate.toIso8601String(),
      'approvedBy': approvedBy,
      'approvalDate': approvalDate?.toIso8601String(),
    };
  }

  LeaveModel copyWith({
    String? id,
    String? employeeId,
    String? employeeName,
    LeaveType? type,
    DateTime? startDate,
    DateTime? endDate,
    int? daysCount,
    String? reason,
    LeaveStatus? status,
    String? rejectionReason,
    DateTime? requestDate,
    String? approvedBy,
    DateTime? approvalDate,
  }) {
    return LeaveModel(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      type: type ?? this.type,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      daysCount: daysCount ?? this.daysCount,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      requestDate: requestDate ?? this.requestDate,
      approvedBy: approvedBy ?? this.approvedBy,
      approvalDate: approvalDate ?? this.approvalDate,
    );
  }

  @override
  List<Object?> get props => [
    id,
    employeeId,
    employeeName,
    type,
    startDate,
    endDate,
    daysCount,
    reason,
    status,
    rejectionReason,
    requestDate,
    approvedBy,
    approvalDate,
  ];
}
