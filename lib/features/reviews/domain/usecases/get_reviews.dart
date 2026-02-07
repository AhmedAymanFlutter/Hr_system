import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/review.dart';
import '../repositories/review_repository.dart';

class GetReviews implements UseCase<Either<Failure, List<Review>>, NoParams> {
  final ReviewRepository repository;

  GetReviews(this.repository);

  @override
  Future<Either<Failure, List<Review>>> call(NoParams params) async {
    return await repository.getReviews();
  }
}
