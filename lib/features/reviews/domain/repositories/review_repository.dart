import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/review.dart';

abstract class ReviewRepository {
  Future<Either<Failure, List<Review>>> getReviews();
  Future<Either<Failure, Review>> createReview(Review review);
}
