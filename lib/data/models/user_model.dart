import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.age,
    required super.gender,
    required super.job,
    required super.location,
    required super.hobbies,
    required super.bio,
    required super.image,
    required super.email,
    required super.password,
    required super.isPremium,
    super.likedUsers,
    super.dislikedUsers,
    super.superLikedUsers,
    super.matches,
  });

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      age: entity.age,
      gender: entity.gender,
      job: entity.job,
      location: entity.location,
      hobbies: entity.hobbies,
      bio: entity.bio,
      image: entity.image,
      email: entity.email,
      password: entity.password,
      isPremium: entity.isPremium,
      likedUsers: entity.likedUsers,
      dislikedUsers: entity.dislikedUsers,
      superLikedUsers: entity.superLikedUsers,
      matches: entity.matches,
    );
  }

  UserEntity toEntity() => this;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      age: json['age'] as int,
      gender: json['gender'] as String,
      job: json['job'] as String,
      location: json['location'] as String,
      hobbies: List<String>.from(json['hobbies'] as List),
      bio: json['bio'] as String,
      image: json['image'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      isPremium: json['isPremium'] as bool,
      likedUsers: List<String>.from(json['likedUsers'] ?? []),
      dislikedUsers: List<String>.from(json['dislikedUsers'] ?? []),
      superLikedUsers: List<String>.from(json['superLikedUsers'] ?? []),
      matches: List<String>.from(json['matches'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'job': job,
      'location': location,
      'hobbies': hobbies,
      'bio': bio,
      'image': image,
      'email': email,
      'password': password,
      'isPremium': isPremium,
      'likedUsers': likedUsers,
      'dislikedUsers': dislikedUsers,
      'superLikedUsers': superLikedUsers,
      'matches': matches,
    };
  }

  @override
  UserModel copyWith({
    String? id,
    String? name,
    int? age,
    String? gender,
    String? job,
    String? location,
    List<String>? hobbies,
    String? bio,
    String? image,
    String? email,
    String? password,
    bool? isPremium,
    List<String>? likedUsers,
    List<String>? dislikedUsers,
    List<String>? superLikedUsers,
    List<String>? matches,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      job: job ?? this.job,
      location: location ?? this.location,
      hobbies: hobbies ?? this.hobbies,
      bio: bio ?? this.bio,
      image: image ?? this.image,
      email: email ?? this.email,
      password: password ?? this.password,
      isPremium: isPremium ?? this.isPremium,
      likedUsers: likedUsers ?? this.likedUsers,
      dislikedUsers: dislikedUsers ?? this.dislikedUsers,
      superLikedUsers: superLikedUsers ?? this.superLikedUsers,
      matches: matches ?? this.matches,
    );
  }
}
