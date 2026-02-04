import 'package:equatable/equatable.dart';

enum UserRole { admin, hr, employee }

class UserModel extends Equatable {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final String? profileImage;
  final String department;
  final String position;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.profileImage,
    required this.department,
    required this.position,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      role: UserRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => UserRole.employee,
      ),
      profileImage: json['profileImage'] as String?,
      department: json['department'] as String,
      position: json['position'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role.name,
      'profileImage': profileImage,
      'department': department,
      'position': position,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    UserRole? role,
    String? profileImage,
    String? department,
    String? position,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      profileImage: profileImage ?? this.profileImage,
      department: department ?? this.department,
      position: position ?? this.position,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    role,
    profileImage,
    department,
    position,
  ];
}
