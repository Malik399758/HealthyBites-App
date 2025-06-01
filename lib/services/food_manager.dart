

import 'package:healthy_bite_project/models/food_item_model.dart';
import 'food_storage_service.dart';

class FoodManager {
  final List<FoodItem> _sampleItems = [
/*    FoodItem(itemName: "Milk", calories: 120, protein: 8.0, carbs: 12.0, fats: 5.0, dateTime: DateTime.now(),imagePath: '', ),
    FoodItem(itemName: "Egg", calories: 70, protein: 6.0, carbs: 1.0, fats: 5.0, dateTime: DateTime.now(),imagePath: '', ),
    FoodItem(itemName: "Apple", calories: 95, protein: 0.5, carbs: 25.0, fats: 0.3, dateTime: DateTime.now(),imagePath: '', ),*/
  ];

  int _currentIndex = 0;

  Future<void> addNextItem() async {
    if (_currentIndex < _sampleItems.length) {
      await FoodStorageService.addFoodItem(_sampleItems[_currentIndex]);
      _currentIndex++;
    }
  }

  Future<List<FoodItem>> loadItems() async {
    return await FoodStorageService.getFoodItems();
  }
}
