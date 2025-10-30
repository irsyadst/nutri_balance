// lib/models/user_model.dart
class User {
  final String id;
  final String name;
  final String email;
  final UserProfile? profile;
  // Tambahkan konstruktor jika belum ada
  User({required this.id, required this.name, required this.email, this.profile});

  // Factory constructor dari JSON (jika diperlukan dari API lain)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      profile: json['profile'] != null ? UserProfile.fromJson(json['profile']) : null,
    );
  }
}

class UserProfile {
  final String gender;
  final int age;
  final double height;
  final double currentWeight;
  final double goalWeight;
  final String activityLevel;
  final List<String> goals;
  final List<String> dietaryRestrictions;
  final List<String> allergies;
  final int? targetCalories;
  final int? targetProteins;
  final int? targetCarbs;
  final int? targetFats;

  // Tambahkan konstruktor jika belum ada
  UserProfile({
    required this.gender,
    required this.age,
    required this.height,
    required this.currentWeight,
    required this.goalWeight,
    required this.activityLevel,
    required this.goals,
    required this.dietaryRestrictions,
    required this.allergies,
    this.targetCalories,
    this.targetProteins,
    this.targetCarbs,
    this.targetFats,
  });


  // Factory constructor dari JSON (jika diperlukan dari API)
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      gender: json['gender'] ?? '',
      age: json['age'] ?? 0,
      height: (json['height'] ?? 0.0).toDouble(),
      currentWeight: (json['currentWeight'] ?? 0.0).toDouble(),
      goalWeight: (json['goalWeight'] ?? 0.0).toDouble(),
      activityLevel: json['activityLevel'] ?? '',
      goals: List<String>.from(json['goals'] ?? []),
      dietaryRestrictions: List<String>.from(json['dietaryRestrictions'] ?? []),
      allergies: List<String>.from(json['allergies'] ?? []),
      targetCalories: json['targetCalories'],
      targetProteins: json['targetProteins'],
      targetCarbs: json['targetCarbs'],
      targetFats: json['targetFats'],
    );
  }

  // toJson untuk mengirim data update ke backend
  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'age': age,
      'height': height,
      'currentWeight': currentWeight,
      'goalWeight': goalWeight,
      'activityLevel': activityLevel,
      'goals': goals, // Backend mengharapkan array, meskipun mungkin hanya satu
      'dietaryRestrictions': dietaryRestrictions,
      'allergies': allergies,
      // Jangan sertakan target nutrisi, karena backend akan menghitungnya ulang
    };
  }
}