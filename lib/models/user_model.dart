// Model Data untuk Pengguna dan Profilnya
class User {
  final String id;
  final String name;
  final String email;
  final UserProfile? profile;
  User({required this.id, required this.name, required this.email, this.profile});
}

class UserProfile {
  final String gender;
  final int age;
  final double height;
  final double currentWeight;
  final double goalWeight;
  final String activityLevel;
  final List<String> goals;
  final List<String> dietaryRestrictions; // Field baru
  final List<String> allergies;           // Field baru

  final int? targetCalories;

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
  });

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