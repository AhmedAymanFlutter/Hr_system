import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_system/features/chat/domain/entities/message.dart';
import 'package:hr_system/features/chat/domain/usecases/get_messages.dart';
import 'package:hr_system/features/chat/domain/usecases/send_message.dart';
import 'chat_detail_state.dart';

class ChatDetailCubit extends Cubit<ChatDetailState> {
  final GetMessages getMessages;
  final SendMessage sendMessageUseCase;

  ChatDetailCubit({required this.getMessages, required this.sendMessageUseCase})
    : super(ChatDetailInitial());

  List<Message> _currentMessages = [];

  Future<void> loadMessages(String chatId) async {
    emit(ChatDetailLoading());
    final result = await getMessages(GetMessagesParams(chatId: chatId));
    result.fold((failure) => emit(ChatDetailError(failure.message)), (
      messages,
    ) {
      _currentMessages = messages;
      emit(ChatDetailLoaded(messages));
    });
  }

  Future<void> sendMessage(String chatId, String content) async {
    final result = await sendMessageUseCase(
      SendMessageParams(chatId: chatId, content: content),
    );

    result.fold((failure) => emit(ChatDetailError(failure.message)), (
      newMessage,
    ) {
      _currentMessages = [..._currentMessages, newMessage];
      emit(ChatDetailLoaded(_currentMessages));
    });
  }
}
