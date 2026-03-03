import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<List<UserEntity>> getPotentialMatches(String currentUserId);
  Future<bool> likeUser(String currentUserId, String targetUserId);
  Future<bool> dislikeUser(String currentUserId, String targetUserId);
  Future<bool> superLikeUser(String currentUserId, String targetUserId);
  Future<List<UserEntity>> getMatches(String currentUserId);
  Future<void> removeMatch(String currentUserId, String targetUserId);
  Future<UserEntity?> getUserById(String userId);
}
