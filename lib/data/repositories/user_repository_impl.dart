import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/local_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  @override
  Future<List<UserEntity>> getPotentialMatches(String currentUserId) async {
    final self = LocalDataSource.findById(currentUserId);
    if (self == null) return [];

    final excludeList = {
      ...self.likedUsers,
      ...self.dislikedUsers,
      ...self.superLikedUsers,
      ...self.matches,
      currentUserId,
    };

    return LocalDataSource.users
        .where((u) => !excludeList.contains(u.id))
        .toList();
  }

  @override
  Future<bool> likeUser(String currentUserId, String targetUserId) async {
    final self = LocalDataSource.findById(currentUserId);
    final target = LocalDataSource.findById(targetUserId);
    if (self == null || target == null) return false;

    final updatedSelf = self.copyWith(
      likedUsers: [...self.likedUsers, targetUserId],
    );
    LocalDataSource.updateUser(updatedSelf);

    final matchFound = target.likedUsers.contains(currentUserId) ||
        target.superLikedUsers.contains(currentUserId) ||
        (targetUserId.startsWith('test_user') &&
            DateTime.now().second % 4 == 0);

    if (matchFound) {
      _createMatch(currentUserId, targetUserId);
      return true;
    }
    return false;
  }

  @override
  Future<bool> dislikeUser(String currentUserId, String targetUserId) async {
    final self = LocalDataSource.findById(currentUserId);
    if (self == null) return false;

    final updatedSelf = self.copyWith(
      dislikedUsers: [...self.dislikedUsers, targetUserId],
    );
    LocalDataSource.updateUser(updatedSelf);
    return false;
  }

  @override
  Future<bool> superLikeUser(String currentUserId, String targetUserId) async {
    final self = LocalDataSource.findById(currentUserId);
    if (self == null || !self.isPremium) return false;

    final updatedSelf = self.copyWith(
      superLikedUsers: [...self.superLikedUsers, targetUserId],
    );
    LocalDataSource.updateUser(updatedSelf);

    _createMatch(currentUserId, targetUserId);
    return true;
  }

  @override
  Future<List<UserEntity>> getMatches(String currentUserId) async {
    final self = LocalDataSource.findById(currentUserId);
    if (self == null) return [];

    return LocalDataSource.users
        .where((u) => self.matches.contains(u.id))
        .toList();
  }

  @override
  Future<void> removeMatch(String currentUserId, String targetUserId) async {
    final self = LocalDataSource.findById(currentUserId);
    final target = LocalDataSource.findById(targetUserId);
    if (self == null || target == null) return;

    LocalDataSource.updateUser(self.copyWith(
      matches: self.matches.where((id) => id != targetUserId).toList(),
    ));
    LocalDataSource.updateUser(target.copyWith(
      matches: target.matches.where((id) => id != currentUserId).toList(),
    ));
  }

  @override
  Future<UserEntity?> getUserById(String userId) async {
    return LocalDataSource.findById(userId);
  }

  void _createMatch(String uid1, String uid2) {
    final u1 = LocalDataSource.findById(uid1);
    final u2 = LocalDataSource.findById(uid2);
    if (u1 == null || u2 == null) return;

    if (!u1.matches.contains(uid2)) {
      LocalDataSource.updateUser(u1.copyWith(matches: [...u1.matches, uid2]));
    }
    if (!u2.matches.contains(uid1)) {
      LocalDataSource.updateUser(u2.copyWith(matches: [...u2.matches, uid1]));
    }
  }
}
