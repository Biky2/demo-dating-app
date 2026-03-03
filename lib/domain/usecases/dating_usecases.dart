import '../../domain/repositories/user_repository.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/entities/message_entity.dart';

class LikeUserUseCase {
  final UserRepository repository;
  
  LikeUserUseCase(this.repository);

  Future<bool> execute(String currentUserId, String targetUserId) async {
    return await repository.likeUser(currentUserId, targetUserId);
  }
}

class SuperLikeUserUseCase {
  final UserRepository repository;
  
  SuperLikeUserUseCase(this.repository);

  Future<bool> execute(String currentUserId, String targetUserId) async {
    return await repository.superLikeUser(currentUserId, targetUserId);
  }
}

class SendMessageUseCase {
  final ChatRepository repository;
  
  SendMessageUseCase(this.repository);

  Future<void> execute(MessageEntity message) async {
    await repository.sendMessage(message);
  }
}
