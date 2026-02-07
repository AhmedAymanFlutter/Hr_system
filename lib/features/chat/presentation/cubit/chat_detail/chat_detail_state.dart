import 'package:equatable/equatable.dart';
import 'package:hr_system/features/chat/domain/entities/message.dart';

abstract class ChatDetailState extends Equatable {
  const ChatDetailState();

  @override
  List<Object> get props => [];
}

class ChatDetailInitial extends ChatDetailState {}

class ChatDetailLoading extends ChatDetailState {}

class ChatDetailLoaded extends ChatDetailState {
  final List<Message> messages;

  const ChatDetailLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

class ChatDetailSending extends ChatDetailState {
  final List<Message> currentMessages;
  const ChatDetailSending(this.currentMessages);
  @override
  List<Object> get props => [currentMessages];
}

class ChatDetailError extends ChatDetailState {
  final String message;

  const ChatDetailError(this.message);

  @override
  List<Object> get props => [message];
}
