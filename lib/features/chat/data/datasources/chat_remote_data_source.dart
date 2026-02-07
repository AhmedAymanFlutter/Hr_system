import '../models/chat_model.dart';
import '../models/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatModel>> getChats();
  Future<List<MessageModel>> getMessages(String chatId);
  Future<MessageModel> sendMessage(String chatId, String content);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  // Mock Data
  final List<ChatModel> _chats = [
    ChatModel(
      id: '1',
      participantName: 'Alice HR',
      participantRole: 'HR Manager',
      participantImage: 'https://i.pravatar.cc/150?u=alice',
      lastMessage: MessageModel(
        id: 'm1',
        senderId: 'other',
        content: 'Please submit your documents',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isRead: false,
      ),
      unreadCount: 2,
    ),
    ChatModel(
      id: '2',
      participantName: 'Bob Manager',
      participantRole: 'Direct Manager',
      participantImage: 'https://i.pravatar.cc/150?u=bob',
      lastMessage: MessageModel(
        id: 'm2',
        senderId: 'me',
        content: 'I will be late today',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        isRead: true,
      ),
      unreadCount: 0,
    ),
  ];

  final Map<String, List<MessageModel>> _messages = {
    '1': [
      MessageModel(
        id: 'm1-1',
        senderId: 'me',
        content: 'Hello Alice',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
      ),
      MessageModel(
        id: 'm1-2',
        senderId: 'other',
        content: 'Hi! How can I help you?',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
      ),
      MessageModel(
        id: 'm1',
        senderId: 'other',
        content: 'Please submit your documents',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isRead: false,
      ),
    ],
    '2': [
      MessageModel(
        id: 'm2-1',
        senderId: 'other',
        content: 'Team meeting at 10 AM',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        isRead: true,
      ),
      MessageModel(
        id: 'm2',
        senderId: 'me',
        content: 'I will be late today',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        isRead: true,
      ),
    ],
  };

  @override
  Future<List<ChatModel>> getChats() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _chats;
  }

  @override
  Future<List<MessageModel>> getMessages(String chatId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _messages[chatId] ?? [];
  }

  @override
  Future<MessageModel> sendMessage(String chatId, String content) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newMessage = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'me',
      content: content,
      timestamp: DateTime.now(),
      isRead: true, // Messages sent by me are implicitly read by me
    );

    if (_messages.containsKey(chatId)) {
      _messages[chatId]!.add(newMessage);
    } else {
      _messages[chatId] = [newMessage];
    }

    return newMessage;
  }
}
