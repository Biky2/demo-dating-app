import '../entities/message_entity.dart';

abstract class ChatRepository {
  Future<List<MessageEntity>> getMessages(String senderId, String receiverId);
  Future<void> sendMessage(MessageEntity message);
  Future<void> markAsRead(String messageId);
  Future<int> getUnreadCount(String userId);
}
