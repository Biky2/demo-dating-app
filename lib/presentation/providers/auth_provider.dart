import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_entity.dart';
import 'app_providers.dart';

class AuthNotifier extends StateNotifier<AsyncValue<UserEntity?>> {
  final Ref _ref;

  AuthNotifier(this._ref) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    final authRepo = _ref.read(authRepositoryProvider);
    final user = await authRepo.getCurrentUser();
    state = AsyncValue.data(user);
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _ref.read(authRepositoryProvider).login(email, password);
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> logout() async {
    await _ref.read(authRepositoryProvider).logout();
    state = const AsyncValue.data(null);
  }

  Future<void> togglePremium() async {
    final user = state.value;
    if (user != null) {
      final newStatus = !user.isPremium;
      await _ref.read(authRepositoryProvider).updatePremiumStatus(newStatus);
      state = AsyncValue.data(user.copyWith(isPremium: newStatus));
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<UserEntity?>>((ref) {
  return AuthNotifier(ref);
});
