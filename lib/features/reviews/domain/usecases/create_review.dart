import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/review.dart';
import '../repositories/review_repository.dart';

class CreateReview
    implements UseCase<Either<Failure, Review>, CreateReviewParams> {
  final ReviewRepository repository;

  CreateReview(this.repository);

  @override
  Future<Either<Failure, Review>> call(CreateReviewParams params) async {
    return await repository.createReview(params.review);
  }
}

class CreateReviewParams extends Equatable {
  final Review review;

  const CreateReviewParams({required this.review});

  @override
  List<Object> get props => [review];
}
