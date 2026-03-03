import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_entity.dart';
import 'app_providers.dart';
import 'auth_provider.dart';

class SwipeState {
  final List<UserEntity> potentialMatches;
  final int swipesToday;
  final bool isLoading;
  final UserEntity? lastMatch;

  SwipeState({
    this.potentialMatches = const [],
    this.swipesToday = 0,
    this.isLoading = false,
    this.lastMatch,
  });

  SwipeState copyWith({
    List<UserEntity>? potentialMatches,
    int? swipesToday,
    bool? isLoading,
    UserEntity? lastMatch,
  }) {
    return SwipeState(
      potentialMatches: potentialMatches ?? this.potentialMatches,
      swipesToday: swipesToday ?? this.swipesToday,
      isLoading: isLoading ?? this.isLoading,
      lastMatch: lastMatch ?? this.lastMatch,
    );
  }
}

class SwipeNotifier extends StateNotifier<SwipeState> {
  final Ref _ref;

  SwipeNotifier(this._ref) : super(SwipeState(isLoading: true)) {
    _loadPotentialMatches();
  }

  Future<void> _loadPotentialMatches() async {
    final user = _ref.read(authProvider).value;
    if (user == null) return;

    final repo = _ref.read(userRepositoryProvider);
    final list = await repo.getPotentialMatches(user.id);
    state = state.copyWith(potentialMatches: list, isLoading: false);
  }

  Future<void> like(UserEntity target) async {
    final user = _ref.read(authProvider).value;
    if (user == null) return;

    if (!user.isPremium && state.swipesToday >= 10) {
      throw Exception('Daily swipe limit reached! Upgrade to Pro for unlimited swipes.');
    }

    final repo = _ref.read(userRepositoryProvider);
    final isMatch = await repo.likeUser(user.id, target.id);
    
    state = state.copyWith(
      potentialMatches: state.potentialMatches.where((u) => u.id != target.id).toList(),
      swipesToday: state.swipesToday + 1,
      lastMatch: isMatch ? target : null,
    );
  }

  Future<void> dislike(UserEntity target) async {
    final user = _ref.read(authProvider).value;
    if (user == null) return;

    final repo = _ref.read(userRepositoryProvider);
    await repo.dislikeUser(user.id, target.id);
    
    state = state.copyWith(
      potentialMatches: state.potentialMatches.where((u) => u.id != target.id).toList(),
      swipesToday: state.swipesToday + 1,
    );
  }

  Future<void> superLike(UserEntity target) async {
    final user = _ref.read(authProvider).value;
    if (user == null || !user.isPremium) {
      throw Exception('Super like is a Pro feature!');
    }

    final repo = _ref.read(userRepositoryProvider);
    final isMatch = await repo.superLikeUser(user.id, target.id);
    
    state = state.copyWith(
      potentialMatches: state.potentialMatches.where((u) => u.id != target.id).toList(),
      lastMatch: isMatch ? target : null,
    );
  }

  void clearMatch() => state = state.copyWith(lastMatch: null);
}

final swipeProvider = StateNotifierProvider<SwipeNotifier, SwipeState>((ref) {
  return SwipeNotifier(ref);
});
