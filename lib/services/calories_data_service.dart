import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthy_bite_project/models/calories_model.dart';

class CaloriesDataService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final itemCollection = 'item_collection';

  // total calories

  Future<void> addItemData(String userId, String totalCalories, String protein,
      String carbs, String fats, DateTime dateTime) async {
    try {
      final data = CaloriesModel(
          totalCalories: totalCalories,
          protein: protein,
          carbs: carbs,
          fats: fats,
          dateTime: dateTime);
      await _db.collection(itemCollection).doc(userId).set(data.toMap());
    } catch (e) {
      print('add item error --------->${e.toString()}');
    }
  }

  // add item data

  Future<void> itemDataAddFirebase(
    String userId,
    String calories,
    String protein,
    String carbs,
    String fats,
    DateTime dateTime,
  ) async {
    try {
      final data = CaloriesModel(
          totalCalories: calories,
          protein: protein,
          carbs: carbs,
          fats: fats,
          dateTime: dateTime);
      await _db.collection('separate_item_data').doc(userId).set(data.toMap());
    } catch (e) {
      print('Error -------->${e.toString()}');
    }
  }
}
