

// Food Item Model Here
class FoodItem {
  final String itemName;
  final int calories;
  final double protein;
  final double carbs;
  final double fats;
  final DateTime dateTime;
  final String? imagePath;
  final String userId;

  FoodItem({
    required this.itemName,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.dateTime,
    required this.imagePath,
    required this.userId
  });

  // Convert FoodItem to Map
  Map<String, dynamic> toMap() {
    return {
      'itemName': itemName,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
      'dateTime': dateTime.toIso8601String(),
      'imagePath' : imagePath,
      'userId' : userId
    };
  }

  // Create FoodItem from Map
  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      itemName: map['itemName'],
      calories: map['calories'],
      protein: map['protein'].toDouble(),
      carbs: map['carbs'].toDouble(),
      fats: map['fats'].toDouble(),
      dateTime: DateTime.parse(map['dateTime']),
      imagePath: map['imagePath'],
      userId: map['userId']
    );
  }
}
