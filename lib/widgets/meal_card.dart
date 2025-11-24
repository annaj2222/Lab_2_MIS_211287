import 'package:flutter/material.dart';
import '../models/meal_summary.dart';

class MealCard extends StatelessWidget {
  final MealSummary meal;
  const MealCard({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: meal.strMealThumb.isNotEmpty
                ? Image.network(
              meal.strMealThumb,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (c, e, s) => const Center(child: Icon(Icons.broken_image)),
            )
                : const Center(child: Icon(Icons.broken_image)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              meal.strMeal,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
