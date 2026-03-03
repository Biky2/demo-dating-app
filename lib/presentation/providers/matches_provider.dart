import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_entity.dart';
import 'app_providers.dart';
import 'auth_provider.dart';

final matchesProvider = FutureProvider<List<UserEntity>>((ref) async {
  final user = ref.watch(authProvider).value;
  if (user == null) return [];

  final repo = ref.watch(userRepositoryProvider);
  return repo.getMatches(user.id);
});

class MatchActionsNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  MatchActionsNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<void> removeMatch(String targetUserId) async {
    final user = _ref.read(authProvider).value;
    if (user == null) return;

    state = const AsyncValue.loading();
    try {
      final repo = _ref.read(userRepositoryProvider);
      await repo.removeMatch(user.id, targetUserId);
      _ref.invalidate(matchesProvider);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final matchActionsProvider = StateNotifierProvider<MatchActionsNotifier, AsyncValue<void>>((ref) {
  return MatchActionsNotifier(ref);
});
