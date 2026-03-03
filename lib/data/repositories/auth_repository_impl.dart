import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SharedPreferences _prefs;
  static const String _authKey = 'current_user';

  AuthRepositoryImpl(this._prefs);

  @override
  Future<UserEntity?> login(String email, String password) async {
    final user = LocalDataSource.users.firstWhere(
      (u) => u.email == email && u.password == password,
      orElse: () => throw Exception('Invalid credentials'),
    );
    
    await _prefs.setString(_authKey, jsonEncode(user.toJson()));
    return user;
  }

  @override
  Future<void> logout() async {
    await _prefs.remove(_authKey);
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final userData = _prefs.getString(_authKey);
    if (userData == null) return null;
    
    final userJson = jsonDecode(userData) as Map<String, dynamic>;
    // Refresh from LocalDataSource to get updated state (matches etc)
    final freshUser = LocalDataSource.findById(userJson['id'] as String);
    if (freshUser != null) return freshUser;

    return UserModel.fromJson(userJson);
  }

  @override
  Future<void> updatePremiumStatus(bool isPremium) async {
    final currentUser = await getCurrentUser();
    if (currentUser != null) {
      final model = UserModel.fromEntity(currentUser);
      final updated = model.copyWith(isPremium: isPremium);
      LocalDataSource.updateUser(updated);
      await _prefs.setString(_authKey, jsonEncode(updated.toJson()));
    }
  }
}
