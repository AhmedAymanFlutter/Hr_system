import 'package:equatable/equatable.dart';

class TaskModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime deadline;
  final bool isCompleted;

  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.isCompleted,
  });

  @override
  List<Object?> get props => [id, title, description, deadline, isCompleted];
}
