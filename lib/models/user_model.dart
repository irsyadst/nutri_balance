// lib/models/user_model.dart
class User {
  final String id;
  final String name;
  final String email;
  final UserProfile? profile;
  User({required this.id, required this.name, required this.email, this.profile});

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

  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'age': age,
      'height': height,
      'currentWeight': currentWeight,
      'goalWeight': goalWeight,
      'activityLevel': activityLevel,
      'goals': goals,
      'dietaryRestrictions': dietaryRestrictions,
      'allergies': allergies,
    };
  }
}