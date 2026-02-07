import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_system/core/usecases/usecase.dart';
import 'package:hr_system/features/chat/domain/usecases/get_chats.dart';
import 'chat_list_state.dart';

class ChatListCubit extends Cubit<ChatListState> {
  final GetChats getChats;

  ChatListCubit({required this.getChats}) : super(ChatListInitial());

  Future<void> loadChats() async {
    emit(ChatListLoading());
    final result = await getChats(NoParams());
    result.fold(
      (failure) => emit(ChatListError(failure.message)),
      (chats) => emit(ChatListLoaded(chats)),
    );
  }
}
