import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/meal_summary.dart';
import '../services/api_service.dart';
import '../widgets/meal_card.dart';
import 'meal_detail_screen.dart';

class CategoryMealsScreen extends StatefulWidget {
  final String category;
  const CategoryMealsScreen({super.key, required this.category});

  @override
  State<CategoryMealsScreen> createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {
  late Future<List<MealSummary>> _futureMeals;
  String query = '';
  List<MealSummary>? _searchResults;

  @override
  void initState() {
    super.initState();
    final api = Provider.of<ApiService>(context, listen: false);
    _futureMeals = api.fetchMealsByCategory(widget.category);
  }

  Future<void> _doSearch(String q) async {
    q = q.trim();
    if (q.isEmpty) {
      setState(() {
        _searchResults = null;
      });
      return;
    }
    final api = Provider.of<ApiService>(context, listen: false);
    final results = await api.searchMeals(q);
    final filtered = results.where((m) => m.strMeal.isNotEmpty).toList();
    setState(() {
      _searchResults = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    final listToShow = _searchResults;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Пребарај јадења во категоријата (или глобално)',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (v) {
                query = v;
              },
              onSubmitted: (v) => _doSearch(v),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<MealSummary>>(
              future: _futureMeals,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Грешка: ${snapshot.error}'));
                } else {
                  final meals = snapshot.data ?? [];
                  final display = listToShow ?? meals;
                  if (display.isEmpty) {
                    return const Center(child: Text('Нема резултати'));
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: display.length,
                    itemBuilder: (ctx, idx) {
                      final meal = display[idx];
                      return GestureDetector(
                        onTap: () async {
                          final api = Provider.of<ApiService>(context, listen: false);
                          try {
                            final detail = await api.lookupMealById(meal.idMeal);
                            if (!mounted) return;
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => MealDetailScreen(mealDetail: detail),
                              ),
                            );
                          } catch (e) {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Грешка: $e')));
                          }
                        },
                        child: MealCard(meal: meal),
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
