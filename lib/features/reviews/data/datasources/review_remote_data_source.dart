import '../models/review_model.dart';

abstract class ReviewRemoteDataSource {
  Future<List<ReviewModel>> getReviews();
  Future<ReviewModel> createReview(ReviewModel review);
}

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  // Mock Data
  final List<ReviewModel> _reviews = [
    ReviewModel(
      id: '1',
      employeeId: 'emp1',
      employeeName: 'John Doe',
      reviewerId: 'admin1',
      reviewerName: 'Admin',
      date: DateTime.now().subtract(const Duration(days: 30)),
      rating: 4.5,
      feedback: 'Excellent performance in Q1. Delivered all projects on time.',
      goals: ['Lead the new mobile app project', 'Mentor junior developers'],
    ),
    ReviewModel(
      id: '2',
      employeeId: 'emp2',
      employeeName: 'Jane Smith',
      reviewerId: 'admin1',
      reviewerName: 'Admin',
      date: DateTime.now().subtract(const Duration(days: 60)),
      rating: 3.8,
      feedback:
          'Good work, but needs to improve communication with other teams.',
      goals: ['Attend communication workshop', 'Host weekly syncs'],
    ),
  ];

  @override
  Future<List<ReviewModel>> getReviews() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _reviews;
  }

  @override
  Future<ReviewModel> createReview(ReviewModel review) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final newReview = ReviewModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      employeeId: review.employeeId,
      employeeName: review.employeeName,
      reviewerId: review.reviewerId,
      reviewerName: review.reviewerName,
      date: DateTime.now(),
      rating: review.rating,
      feedback: review.feedback,
      goals: review.goals,
    );
    _reviews.insert(0, newReview);
    return newReview;
  }
}
