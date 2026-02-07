import 'package:equatable/equatable.dart';

enum EventType { holiday, event, leave }

class Event extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final EventType type;

  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.type,
  });

  @override
  List<Object?> get props => [id, title, description, date, type];
}
