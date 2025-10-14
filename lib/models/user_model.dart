// Model Data untuk Pengguna dan Profilnya
class User {
  final String id;
  final String name;
  final String email;
  final UserProfile? profile;
  User({required this.id, required this.name, required this.email, this.profile});
}

class UserProfile {
  // Data dari kuesioner
  final String gender;
  final int age;
  final double height;
  final double currentWeight;
  final double goalWeight;
  final String wakeUpTime;
  final String sleepTime;
  final String firstMealTime;
  final String lastMealTime;
  final String dailyMealIntake;
  final String climate;
  final String waterIntake;
  final String activityLevel;
  final List<String> goals;
  final String fastingExperience;
  final List<String> healthIssues;

  // Data yang dihitung oleh server (opsional di sini, tapi ada di backend)
  final int? targetCalories;

  UserProfile({
    required this.gender,
    required this.age,
    required this.height,
    required this.currentWeight,
    required this.goalWeight,
    required this.wakeUpTime,
    required this.sleepTime,
    required this.firstMealTime,
    required this.lastMealTime,
    required this.dailyMealIntake,
    required this.climate,
    required this.waterIntake,
    required this.activityLevel,
    required this.goals,
    required this.fastingExperience,
    required this.healthIssues,
    this.targetCalories,
  });

  // Fungsi untuk mengubah data ini menjadi format JSON untuk dikirim ke API
  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'age': age,
      'height': height,
      'currentWeight': currentWeight,
      'goalWeight': goalWeight,
      'wakeUpTime': wakeUpTime,
      'sleepTime': sleepTime,
      'firstMealTime': firstMealTime,
      'lastMealTime': lastMealTime,
      'dailyMealIntake': dailyMealIntake,
      'climate': climate,
      'waterIntake': waterIntake,
      'activityLevel': activityLevel,
      'goals': goals,
      'fastingExperience': fastingExperience,
      'healthIssues': healthIssues,
    };
  }
}

