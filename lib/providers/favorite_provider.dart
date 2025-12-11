import 'package:flutter/material.dart';
import '../models/meal_detail.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<MealDetail> _favorites = [];

  List<MealDetail> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(String id) {
    return _favorites.any((m) => m.idMeal == id);
  }

  void toggleFavorite(MealDetail meal) {
    final exists = isFavorite(meal.idMeal);
    if (exists) {
      _favorites.removeWhere((m) => m.idMeal == meal.idMeal);
    } else {
      _favorites.add(meal);
    }
    notifyListeners();
  }
}
