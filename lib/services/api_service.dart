import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal_summary.dart';
import '../models/meal_detail.dart';

class ApiService {
  final String base = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<Category>> fetchCategories() async {
    final uri = Uri.parse('$base/categories.php');
    final res = await http.get(uri);
    if (res.statusCode != 200) throw Exception('Failed to load categories');
    final data = jsonDecode(res.body);
    final List categories = data['categories'] ?? [];
    return categories.map((c) => Category.fromJson(c)).toList();
  }

  Future<List<MealSummary>> fetchMealsByCategory(String category) async {
    final uri = Uri.parse('$base/filter.php?c=$category');
    final res = await http.get(uri);
    if (res.statusCode != 200) throw Exception('Failed to load meals for $category');
    final data = jsonDecode(res.body);
    final List meals = data['meals'] ?? [];
    return meals.map((m) => MealSummary.fromJson(m)).toList();
  }

  Future<List<MealSummary>> searchMeals(String query) async {
    final uri = Uri.parse('$base/search.php?s=$query');
    final res = await http.get(uri);
    if (res.statusCode != 200) throw Exception('Search failed');
    final data = jsonDecode(res.body);
    final List? meals = data['meals'];
    if (meals == null) return [];
    return meals.map((m) => MealSummary.fromJson(m)).toList();
  }

  Future<MealDetail> lookupMealById(String id) async {
    final uri = Uri.parse('$base/lookup.php?i=$id');
    final res = await http.get(uri);
    if (res.statusCode != 200) throw Exception('Lookup failed for $id');
    final data = jsonDecode(res.body);
    final List meals = data['meals'] ?? [];
    if (meals.isEmpty) throw Exception('Meal not found');
    return MealDetail.fromJson(meals.first);
  }

  Future<MealDetail> fetchRandomMeal() async {
    final uri = Uri.parse('$base/random.php');
    final res = await http.get(uri);
    if (res.statusCode != 200) throw Exception('Random fetch failed');
    final data = jsonDecode(res.body);
    final List meals = data['meals'] ?? [];
    if (meals.isEmpty) throw Exception('No random meal');
    return MealDetail.fromJson(meals.first);
  }
}
