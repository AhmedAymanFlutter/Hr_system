import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/review.dart';
import '../../domain/repositories/review_repository.dart';
import '../datasources/review_remote_data_source.dart';
import '../models/review_model.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource remoteDataSource;

  ReviewRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Review>>> getReviews() async {
    try {
      final reviews = await remoteDataSource.getReviews();
      return Right<Failure, List<Review>>(reviews);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Review>> createReview(Review review) async {
    try {
      final reviewModel = ReviewModel(
        id: review.id,
        employeeId: review.employeeId,
        employeeName: review.employeeName,
        reviewerId: review.reviewerId,
        reviewerName: review.reviewerName,
        date: review.date,
        rating: review.rating,
        feedback: review.feedback,
        goals: review.goals,
      );
      final createdReview = await remoteDataSource.createReview(reviewModel);
      return Right<Failure, Review>(createdReview);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
