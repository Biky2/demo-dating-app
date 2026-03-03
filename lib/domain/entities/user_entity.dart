import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String job;
  final String location;
  final List<String> hobbies;
  final String bio;
  final String image;
  final String email;
  final String password;
  final bool isPremium;
  final List<String> likedUsers;
  final List<String> dislikedUsers;
  final List<String> superLikedUsers;
  final List<String> matches;

  const UserEntity({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.job,
    required this.location,
    required this.hobbies,
    required this.bio,
    required this.image,
    required this.email,
    required this.password,
    required this.isPremium,
    this.likedUsers = const [],
    this.dislikedUsers = const [],
    this.superLikedUsers = const [],
    this.matches = const [],
  });

  UserEntity copyWith({
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
    return UserEntity(
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

  @override
  List<Object?> get props => [
        id,
        name,
        age,
        gender,
        job,
        location,
        hobbies,
        bio,
        image,
        email,
        password,
        isPremium,
        likedUsers,
        dislikedUsers,
        superLikedUsers,
        matches,
      ];
}
