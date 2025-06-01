

import 'dart:convert';
import 'package:healthy_bite_project/models/food_item_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class FoodStorageService {
  static const String _key = 'foodItems';

  // Add a new FoodItem
  static Future<void> addFoodItem(FoodItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final existingData = prefs.getString(_key);

    List<Map<String, dynamic>> items = [];

    if (existingData != null) {
      final List decoded = jsonDecode(existingData);
      items = decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    }

    items.add(item.toMap());

    await prefs.setString(_key, jsonEncode(items));
  }

  // Get all FoodItems
  static Future<List<FoodItem>> getFoodItems() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);

    if (data == null) return [];

    final List decoded = jsonDecode(data);
    return decoded
        .map((item) => FoodItem.fromMap(Map<String, dynamic>.from(item)))
        .toList();
  }
}
