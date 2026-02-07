import '../../domain/entities/review.dart';

class ReviewModel extends Review {
  const ReviewModel({
    required super.id,
    required super.employeeId,
    required super.employeeName,
    required super.reviewerId,
    required super.reviewerName,
    required super.date,
    required super.rating,
    required super.feedback,
    required super.goals,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      employeeId: json['employeeId'],
      employeeName: json['employeeName'],
      reviewerId: json['reviewerId'],
      reviewerName: json['reviewerName'],
      date: DateTime.parse(json['date']),
      rating: (json['rating'] as num).toDouble(),
      feedback: json['feedback'],
      goals: List<String>.from(json['goals']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'employeeName': employeeName,
      'reviewerId': reviewerId,
      'reviewerName': reviewerName,
      'date': date.toIso8601String(),
      'rating': rating,
      'feedback': feedback,
      'goals': goals,
    };
  }
}
