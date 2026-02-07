import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_system/config/injection_container.dart';
import '../cubit/review_cubit.dart';
import '../cubit/review_state.dart';

class ReviewListPage extends StatelessWidget {
  const ReviewListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ReviewCubit>()..loadReviews(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Performance Reviews')),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.push('/reviews/create'),
          child: const Icon(Icons.add),
        ),
        body: BlocBuilder<ReviewCubit, ReviewState>(
          builder: (context, state) {
            if (state is ReviewLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ReviewLoaded) {
              if (state.reviews.isEmpty) {
                return const Center(child: Text('No reviews found'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.reviews.length,
                itemBuilder: (context, index) {
                  final review = state.reviews[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                review.employeeName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getRatingColor(review.rating),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  review.rating.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text("Reviewed by: ${review.reviewerName}"),
                          Text(
                            "Date: ${review.date.day}/${review.date.month}/${review.date.year}",
                          ),
                          const Divider(),
                          const Text(
                            "Feedback:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(review.feedback),
                          if (review.goals.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            const Text(
                              "Goals:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            ...review.goals.map((goal) => Text("• $goal")),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is ReviewError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Color _getRatingColor(double rating) {
    if (rating >= 4.0) return Colors.green;
    if (rating >= 3.0) return Colors.orange;
    return Colors.red;
  }
}
