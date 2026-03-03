import 'dart:math';
import 'package:uuid/uuid.dart';
import '../models/user_model.dart';

class LocalDataSource {
  static final List<UserModel> _users = [];
  
  static void initializeData() {
    if (_users.isNotEmpty) return;
    
    final random = Random();
    final genders = ['Male', 'Female'];
    final jobs = ['Engineer', 'Designer', 'Doctor', 'Teacher', 'Artist', 'Student', 'Chef', 'Lawyer', 'Model', 'Photographer'];
    final locations = ['New York', 'Los Angeles', 'Chicago', 'San Francisco', 'Miami', 'London', 'Paris', 'Tokyo', 'Berlin', 'Mumbai'];
    final hobbyPool = ['Reading', 'Hiking', 'Gaming', 'Cooking', 'Traveling', 'Movies', 'Music', 'Fitness', 'Art', 'Coding', 'Dancing', 'Yoga'];

    // Add specifically requested test accounts
    for (int i = 1; i <= 5; i++) {
      _users.add(_generateUser(
        id: 'test_user_$i',
        email: 'test$i@mail.com',
        password: '123456',
        isPremium: i == 1, // Make first user premium for testing
        random: random,
        genders: genders,
        jobs: jobs,
        locations: locations,
        hobbyPool: hobbyPool,
      ));
    }

    // Add remaining 45 users
    for (int i = 6; i <= 50; i++) {
      _users.add(_generateUser(
        id: const Uuid().v4(),
        random: random,
        genders: genders,
        jobs: jobs,
        locations: locations,
        hobbyPool: hobbyPool,
      ));
    }
  }

  static UserModel _generateUser({
    required String id,
    String? email,
    String? password,
    bool isPremium = false,
    required Random random,
    required List<String> genders,
    required List<String> jobs,
    required List<String> locations,
    required List<String> hobbyPool,
  }) {
    final gender = genders[random.nextInt(genders.length)];
    final firstName = _getFirstName(gender, random);
    final lastName = _getLastName(random);
    
    return UserModel(
      id: id,
      name: '$firstName $lastName',
      age: 18 + random.nextInt(23), // 18-40
      gender: gender,
      job: jobs[random.nextInt(jobs.length)],
      location: locations[random.nextInt(locations.length)],
      hobbies: (List.from(hobbyPool)..shuffle()).take(3).toList().cast<String>(),
      bio: "Hi, I'm $firstName. I love life and meeting new people. Let's see if we match!",
      image: 'https://i.pravatar.cc/300?img=${random.nextInt(70)}',
      email: email ?? '${firstName.toLowerCase()}.${lastName.toLowerCase()}@example.com',
      password: password ?? 'password',
      isPremium: isPremium,
    );
  }

  static String _getFirstName(String gender, Random random) {
    final males = ['John', 'David', 'James', 'Michael', 'Robert', 'William', 'Alex', 'Chris', 'Ryan', 'Leo'];
    final females = ['Emma', 'Olivia', 'Sophia', 'Isabella', 'Mia', 'Ava', 'Charlotte', 'Amelia', 'Luna', 'Zoe'];
    return (gender == 'Male' ? males : females)[random.nextInt(10)];
  }

  static String _getLastName(Random random) {
    final lastNames = ['Smith', 'Johnson', 'Brown', 'Taylor', 'Miller', 'Wilson', 'Anderson', 'Thomas', 'Jackson', 'White'];
    return lastNames[random.nextInt(10)];
  }

  static List<UserModel> get users => _users;
  
  static UserModel? findByEmail(String email) {
    return _users.firstWhere((u) => u.email == email);
  }

  static UserModel? findById(String id) {
    final index = _users.indexWhere((u) => u.id == id);
    return index != -1 ? _users[index] : null;
  }

  static void updateUser(UserModel updatedUser) {
    final index = _users.indexWhere((u) => u.id == updatedUser.id);
    if (index != -1) {
      _users[index] = updatedUser;
    }
  }
}
