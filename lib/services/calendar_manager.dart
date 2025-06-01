
import 'package:healthy_bite_project/models/food_item_model.dart';
import 'package:intl/intl.dart';

class CalendarManager {
  final List<FoodItem> foodItems;

  CalendarManager(this.foodItems);

  Map<String, List<FoodItem>> get itemsGroupedByDate {
    Map<String, List<FoodItem>> grouped = {};
    for (var item in foodItems) {
      String dateKey = DateFormat('yyyy-MM-dd').format(item.dateTime);
      grouped.putIfAbsent(dateKey, () => []).add(item);
    }
    return grouped;
  }

  List<FoodItem> get todayItems {
    String todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return itemsGroupedByDate[todayKey] ?? [];
  }
}
