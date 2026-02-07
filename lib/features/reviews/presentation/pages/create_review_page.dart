import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_system/config/injection_container.dart';
import '../../domain/entities/review.dart';
import '../cubit/review_cubit.dart';
import '../cubit/review_state.dart';

class CreateReviewPage extends StatefulWidget {
  const CreateReviewPage({super.key});

  @override
  State<CreateReviewPage> createState() => _CreateReviewPageState();
}

class _CreateReviewPageState extends State<CreateReviewPage> {
  final _formKey = GlobalKey<FormState>();
  final _employeeNameController = TextEditingController();
  final _ratingController = TextEditingController();
  final _feedbackController = TextEditingController();
  final _goalsController = TextEditingController();

  @override
  void dispose() {
    _employeeNameController.dispose();
    _ratingController.dispose();
    _feedbackController.dispose();
    _goalsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ReviewCubit>(),
      child: BlocListener<ReviewCubit, ReviewState>(
        listener: (context, state) {
          if (state is ReviewOperationSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            context.pop();
          } else if (state is ReviewError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('New Performance Review')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _employeeNameController,
                    decoration: const InputDecoration(
                      labelText: 'Employee Name',
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _ratingController,
                    decoration: const InputDecoration(
                      labelText: 'Rating (1.0 - 5.0)',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Required';
                      final rating = double.tryParse(value);
                      if (rating == null || rating < 1.0 || rating > 5.0) {
                        return 'Invalid rating';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _feedbackController,
                    decoration: const InputDecoration(labelText: 'Feedback'),
                    maxLines: 4,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _goalsController,
                    decoration: const InputDecoration(
                      labelText: 'Goals (comma separated)',
                      hintText: 'Learn Flutter, Improve communication',
                    ),
                  ),
                  const SizedBox(height: 32),
                  Builder(
                    builder: (context) {
                      return ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final goals = _goalsController.text
                                .split(',')
                                .map((e) => e.trim())
                                .where((e) => e.isNotEmpty)
                                .toList();

                            final newReview = Review(
                              id: '',
                              employeeId: 'temp_emp_id',
                              employeeName: _employeeNameController.text,
                              reviewerId: 'admin_id',
                              reviewerName: 'Admin',
                              date: DateTime.now(),
                              rating: double.parse(_ratingController.text),
                              feedback: _feedbackController.text,
                              goals: goals,
                            );

                            context.read<ReviewCubit>().addReview(newReview);
                          }
                        },
                        child: const Text('Submit Review'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
