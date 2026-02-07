import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class SendMessage
    implements UseCase<Either<Failure, Message>, SendMessageParams> {
  final ChatRepository repository;

  SendMessage(this.repository);

  @override
  Future<Either<Failure, Message>> call(SendMessageParams params) async {
    return await repository.sendMessage(params.chatId, params.content);
  }
}

class SendMessageParams extends Equatable {
  final String chatId;
  final String content;

  const SendMessageParams({required this.chatId, required this.content});

  @override
  List<Object> get props => [chatId, content];
}
