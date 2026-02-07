import '../../domain/entities/chat.dart';
import 'message_model.dart';

class ChatModel extends Chat {
  const ChatModel({
    required super.id,
    required super.participantName,
    required super.participantRole,
    required super.participantImage,
    required super.lastMessage,
    required super.unreadCount,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      participantName: json['participantName'],
      participantRole: json['participantRole'],
      participantImage: json['participantImage'],
      lastMessage: MessageModel.fromJson(json['lastMessage']),
      unreadCount: json['unreadCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participantName': participantName,
      'participantRole': participantRole,
      'participantImage': participantImage,
      'lastMessage': (lastMessage as MessageModel).toJson(),
      'unreadCount': unreadCount,
    };
  }
}
