class NutritionalCalculator {
  static Map<String, dynamic> calculateNeeds({
    required String gender,
    required int age,
    required int height,
    required int currentWeight,
    required String activityLevel,
    required String goal,
  }) {
    // 1. Hitung BMR (Basal Metabolic Rate) menggunakan rumus Mifflin-St Jeor
    double bmr;
    if (gender == 'Pria') {
      bmr = 88.362 + (13.397 * currentWeight) + (4.799 * height) - (5.677 * age);
    } else { // Asumsi 'Wanita'
      bmr = 447.593 + (9.247 * currentWeight) + (3.098 * height) - (4.330 * age);
    }

    // 2. Tentukan Pengali Aktivitas untuk menghitung TDEE
    double activityMultiplier;
    switch (activityLevel) {
      case 'Menetap':
        activityMultiplier = 1.2;
        break;
      case 'Ringan Aktif':
        activityMultiplier = 1.375;
        break;
      case 'Cukup Aktif':
        activityMultiplier = 1.55;
        break;
      case 'Sangat Aktif':
        activityMultiplier = 1.725;
        break;
      case 'Sangat Aktif Sekali':
        activityMultiplier = 1.9; // Nilai umum untuk aktivitas ekstra berat
        break;
      default:
        activityMultiplier = 1.2;
    }
    double tdee = bmr * activityMultiplier;

    // 3. Sesuaikan kalori target berdasarkan tujuan
    double targetCalories = tdee;
    if (goal == 'Penurunan Berat Badan') {
      targetCalories -= 500;
    } else if (goal == 'Pertambahan Berat Badan') {
      targetCalories += 500;
    }
    // Tidak ada perubahan untuk 'Pertahankan Berat Badan'

    // 4. Hitung Makronutrien (Karbohidrat, Protein, Lemak)
    final targetCarbs = (targetCalories * 0.45) / 4;
    final targetProteins = (targetCalories * 0.30) / 4;
    final targetFats = (targetCalories * 0.25) / 9;

    // 5. Hitung IMT (Indeks Massa Tubuh)
    final heightInMeters = height / 100;
    final bmi = currentWeight / (heightInMeters * heightInMeters);
    String bmiCategory;
    if (bmi < 18.5) {
      bmiCategory = "Kurus";
    } else if (bmi >= 18.5 && bmi <= 22.9) {
      bmiCategory = "Normal";
    } else if (bmi >= 23 && bmi <= 29.9) {
      bmiCategory = "Berlebih";
    } else {
      bmiCategory = "Obesitas";
    }

    return {
      'calories': targetCalories.round(),
      'proteins': targetProteins.round(),
      'carbs': targetCarbs.round(),
      'fats': targetFats.round(),
      'bmi': bmi.toStringAsFixed(1),
      'bmiCategory': bmiCategory,
    };
  }
}