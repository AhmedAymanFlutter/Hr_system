import 'package:equatable/equatable.dart';

enum EmployeeStatus { active, inactive, onLeave, terminated }

class EmployeeModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String department;
  final String position;
  final EmployeeStatus status;
  final DateTime joinDate;
  final double salary;
  final String? profileImage;
  final String address;
  final DateTime? dateOfBirth;
  final String? emergencyContact;

  const EmployeeModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.department,
    required this.position,
    required this.status,
    required this.joinDate,
    required this.salary,
    this.profileImage,
    required this.address,
    this.dateOfBirth,
    this.emergencyContact,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      department: json['department'] as String,
      position: json['position'] as String,
      status: EmployeeStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => EmployeeStatus.active,
      ),
      joinDate: DateTime.parse(json['joinDate'] as String),
      salary: (json['salary'] as num).toDouble(),
      profileImage: json['profileImage'] as String?,
      address: json['address'] as String,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
      emergencyContact: json['emergencyContact'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'department': department,
      'position': position,
      'status': status.name,
      'joinDate': joinDate.toIso8601String(),
      'salary': salary,
      'profileImage': profileImage,
      'address': address,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'emergencyContact': emergencyContact,
    };
  }

  EmployeeModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? department,
    String? position,
    EmployeeStatus? status,
    DateTime? joinDate,
    double? salary,
    String? profileImage,
    String? address,
    DateTime? dateOfBirth,
    String? emergencyContact,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      department: department ?? this.department,
      position: position ?? this.position,
      status: status ?? this.status,
      joinDate: joinDate ?? this.joinDate,
      salary: salary ?? this.salary,
      profileImage: profileImage ?? this.profileImage,
      address: address ?? this.address,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      emergencyContact: emergencyContact ?? this.emergencyContact,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    department,
    position,
    status,
    joinDate,
    salary,
    profileImage,
    address,
    dateOfBirth,
    emergencyContact,
  ];
}
