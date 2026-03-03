import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/message_entity.dart';
import 'app_providers.dart';
import 'auth_provider.dart';
import 'package:uuid/uuid.dart';

final chatMessagesProvider = FutureProvider.family<List<MessageEntity>, String>((ref, otherUserId) async {
  final user = ref.watch(authProvider).value;
  if (user == null) return [];

  final repo = ref.watch(chatRepositoryProvider);
  return repo.getMessages(user.id, otherUserId);
});

class ChatActionsNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  ChatActionsNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<void> sendMessage(String targetUserId, String content) async {
    final user = _ref.read(authProvider).value;
    if (user == null) return;

    state = const AsyncValue.loading();
    try {
      final repo = _ref.read(chatRepositoryProvider);
      final message = MessageEntity(
        id: const Uuid().v4(),
        senderId: user.id,
        receiverId: targetUserId,
        content: content,
        timestamp: DateTime.now(),
      );
      await repo.sendMessage(message);
      _ref.invalidate(chatMessagesProvider(targetUserId));
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> markAsRead(String messageId, String targetUserId) async {
    final repo = _ref.read(chatRepositoryProvider);
    await repo.markAsRead(messageId);
    _ref.invalidate(chatMessagesProvider(targetUserId));
  }
}

final chatActionsProvider = StateNotifierProvider<ChatActionsNotifier, AsyncValue<void>>((ref) {
  return ChatActionsNotifier(ref);
});

final unreadMessagesCountProvider = FutureProvider<int>((ref) async {
  final user = ref.watch(authProvider).value;
  if (user == null) return 0;

  final repo = ref.watch(chatRepositoryProvider);
  return repo.getUnreadCount(user.id);
});
