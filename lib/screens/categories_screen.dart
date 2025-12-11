import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../models/category.dart';
import '../widgets/category_card.dart';
import 'category_meals_screen.dart';
import 'favorites_screen.dart';
import 'meal_detail_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late Future<List<Category>> _futureCategories;
  String query = '';

  @override
  void initState() {
    super.initState();
    final api = Provider.of<ApiService>(context, listen: false);
    _futureCategories = api.fetchCategories();
  }

  void _openRandomRecipe() async {
    final api = Provider.of<ApiService>(context, listen: false);
    try {
      final meal = await api.fetchRandomMeal();
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => MealDetailScreen(mealDetail: meal),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Грешка: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Категории'),
        actions: [
          IconButton(
            icon: const Icon(Icons.star),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesScreen()),
              );
            },
          ),
          IconButton(
            onPressed: _openRandomRecipe,
            icon: const Icon(Icons.casino_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Пребарај категории',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (v) {
                setState(() {
                  query = v.trim().toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Category>>(
              future: _futureCategories,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Грешка: ${snapshot.error}'));
                } else {
                  final categories = snapshot.data ?? [];
                  final filtered = categories.where((c) {
                    return c.strCategory.toLowerCase().contains(query) ||
                        c.strCategoryDescription.toLowerCase().contains(query);
                  }).toList();

                  return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: filtered.length,
                    itemBuilder: (ctx, idx) {
                      final cat = filtered[idx];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => CategoryMealsScreen(category: cat.strCategory)));
                        },
                        child: CategoryCard(category: cat),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
