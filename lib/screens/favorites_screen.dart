import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favorite_provider.dart';
import 'meal_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fav = Provider.of<FavoriteProvider>(context).favorites;

    return Scaffold(
      appBar: AppBar(title: const Text("Омилени рецепти")),
      body: fav.isEmpty
          ? const Center(child: Text("Немаш додадено омилени рецепти"))
          : ListView.builder(
        itemCount: fav.length,
        itemBuilder: (_, i) {
          final meal = fav[i];
          return ListTile(
            leading: Image.network(meal.strMealThumb, width: 60, height: 60),
            title: Text(meal.strMeal),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MealDetailScreen(mealDetail: meal)),
              );
            },
          );
        },
      ),
    );
  }
}
