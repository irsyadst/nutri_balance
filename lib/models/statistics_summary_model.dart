import 'dart:convert';

StatisticsSummary statisticsSummaryFromJson(String str) => StatisticsSummary.fromJson(json.decode(str));

class StatisticsSummary {
  final int caloriesToday;
  final double calorieChangePercent;
  final String macroRatio;
  final double macroChangePercent;
  final Map<String, double> calorieDataPerMeal;
  final Map<String, double> macroDataPercentage;

  StatisticsSummary({
    required this.caloriesToday,
    required this.calorieChangePercent,
    required this.macroRatio,
    required this.macroChangePercent,
    required this.calorieDataPerMeal,
    required this.macroDataPercentage,
  });

  factory StatisticsSummary.fromJson(Map<String, dynamic> json) => StatisticsSummary(
    caloriesToday: json["caloriesToday"]?.toInt() ?? 0,
    calorieChangePercent: json["calorieChangePercent"]?.toDouble() ?? 0.0,
    macroRatio: json["macroRatio"] ?? "0/0/0",
    macroChangePercent: json["macroChangePercent"]?.toDouble() ?? 0.0,
    calorieDataPerMeal: Map.from(json["calorieDataPerMeal"] ?? {}).map((k, v) => MapEntry<String, double>(k, v?.toDouble() ?? 0.0)),
    macroDataPercentage: Map.from(json["macroDataPercentage"] ?? {}).map((k, v) => MapEntry<String, double>(k, v?.toDouble() ?? 0.0)),
  );
}