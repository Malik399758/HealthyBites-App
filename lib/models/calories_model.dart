
// Calories model

class CaloriesModel{
  String totalCalories;
  String protein;
  String carbs;
  String fats;
  DateTime dateTime;


  // constructor
  CaloriesModel({
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.totalCalories,
    required this.dateTime
  });

  Map<String, dynamic> toMap() {
    return {
      'totalCalories' : totalCalories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
      'datetime' : dateTime.toIso8601String(),
    };
  }
}