import 'package:equatable/equatable.dart';

class Review extends Equatable {
  final String id;
  final String employeeId;
  final String employeeName;
  final String reviewerId;
  final String reviewerName;
  final DateTime date;
  final double rating; // 1.0 to 5.0
  final String feedback;
  final List<String> goals;

  const Review({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.reviewerId,
    required this.reviewerName,
    required this.date,
    required this.rating,
    required this.feedback,
    required this.goals,
  });

  @override
  List<Object?> get props => [
    id,
    employeeId,
    employeeName,
    reviewerId,
    reviewerName,
    date,
    rating,
    feedback,
    goals,
  ];
}
