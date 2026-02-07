import 'package:equatable/equatable.dart';

enum TaskStatus { todo, inProgress, done }

class Task extends Equatable {
  final String id;
  final String title;
  final String description;
  final String assigneeId;
  final String assigneeName;
  final DateTime dueDate;
  final TaskStatus status;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.assigneeId,
    required this.assigneeName,
    required this.dueDate,
    required this.status,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    assigneeId,
    assigneeName,
    dueDate,
    status,
  ];
}
