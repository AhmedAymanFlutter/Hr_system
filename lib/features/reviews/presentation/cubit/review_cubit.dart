import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_system/core/usecases/usecase.dart';
import '../../domain/entities/review.dart';
import '../../domain/usecases/create_review.dart';
import '../../domain/usecases/get_reviews.dart';
import 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final GetReviews getReviews;
  final CreateReview createReview;

  ReviewCubit({required this.getReviews, required this.createReview})
    : super(ReviewInitial());

  Future<void> loadReviews() async {
    emit(ReviewLoading());
    final result = await getReviews(NoParams());
    result.fold(
      (failure) {
        if (!isClosed) emit(ReviewError(failure.message));
      },
      (reviews) {
        if (!isClosed) emit(ReviewLoaded(reviews));
      },
    );
  }

  Future<void> addReview(Review review) async {
    emit(ReviewLoading());
    final result = await createReview(CreateReviewParams(review: review));
    result.fold(
      (failure) {
        if (!isClosed) emit(ReviewError(failure.message));
      },
      (newReview) {
        if (!isClosed) {
          emit(const ReviewOperationSuccess('Review created successfully'));
          loadReviews();
        }
      },
    );
  }
}
