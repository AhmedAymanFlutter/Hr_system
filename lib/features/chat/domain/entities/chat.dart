import 'package:equatable/equatable.dart';
import 'message.dart';

class Chat extends Equatable {
  final String id;
  final String participantName;
  final String participantRole;
  final String participantImage;
  final Message lastMessage;
  final int unreadCount;

  const Chat({
    required this.id,
    required this.participantName,
    required this.participantRole,
    required this.participantImage,
    required this.lastMessage,
    required this.unreadCount,
  });

  @override
  List<Object?> get props => [
    id,
    participantName,
    participantRole,
    participantImage,
    lastMessage,
    unreadCount,
  ];
}
