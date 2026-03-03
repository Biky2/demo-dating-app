import 'dart:async';
import 'package:uuid/uuid.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../models/message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final List<MessageModel> _messages = [];

  @override
  Future<List<MessageEntity>> getMessages(
      String senderId, String receiverId) async {
    return _messages
        .where((m) =>
            (m.senderId == senderId && m.receiverId == receiverId) ||
            (m.senderId == receiverId && m.receiverId == senderId))
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  @override
  Future<void> sendMessage(MessageEntity message) async {
    _messages.add(message as MessageModel);

    // Simulate auto-reply after 2 seconds
    Timer(const Duration(seconds: 2), () {
      final replies = [
        "Hey!",
        "How's it going?",
        "Wow, that sounds cool!",
        "Haha, nice!",
        "I'd love to meeting up!"
      ];
      final reply = MessageModel(
        id: const Uuid().v4(),
        senderId: message.receiverId,
        receiverId: message.senderId,
        content: replies[message.content.length % replies.length],
        timestamp: DateTime.now(),
        isRead: false,
      );
      _messages.add(reply);
    });
  }

  @override
  Future<void> markAsRead(String messageId) async {
    final index = _messages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      _messages[index] = _messages[index].copyWith(isRead: true);
    }
  }

  @override
  Future<int> getUnreadCount(String userId) async {
    return _messages.where((m) => m.receiverId == userId && !m.isRead).length;
  }
}

// Add copyWith to MessageModel if not already added
extension MessageModelCopy on MessageModel {
  MessageModel copyWith({bool? isRead}) {
    return MessageModel(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      content: content,
      timestamp: timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
}
