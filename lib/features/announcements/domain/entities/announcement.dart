import 'package:equatable/equatable.dart';

class Announcement extends Equatable {
  final String id;
  final String title;
  final String content;
  final DateTime date;
  final String author;

  const Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.author,
  });

  @override
  List<Object?> get props => [id, title, content, date, author];
}
