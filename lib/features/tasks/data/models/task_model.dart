import '../../domain/entities/task.dart';

class TaskModel extends Task {
  const TaskModel({
    required super.id,
    required super.title,
    required super.description,
    required super.assigneeId,
    required super.assigneeName,
    required super.dueDate,
    required super.status,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      assigneeId: json['assigneeId'],
      assigneeName: json['assigneeName'],
      dueDate: DateTime.parse(json['dueDate']),
      status: _mapStatus(json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'assigneeId': assigneeId,
      'assigneeName': assigneeName,
      'dueDate': dueDate.toIso8601String(),
      'status': status.toString().split('.').last,
    };
  }

  static TaskStatus _mapStatus(String status) {
    switch (status) {
      case 'inProgress':
        return TaskStatus.inProgress;
      case 'done':
        return TaskStatus.done;
      default:
        return TaskStatus.todo;
    }
  }
}
