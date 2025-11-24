import 'package:flutter/material.dart';
import '../models/meal_detail.dart';
import '../widgets/ingredient_list.dart';

class MealDetailScreen extends StatelessWidget {
  final MealDetail mealDetail;
  const MealDetailScreen({super.key, required this.mealDetail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mealDetail.strMeal),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (mealDetail.strMealThumb.isNotEmpty)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    mealDetail.strMealThumb,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return SizedBox(height: 220, child: Center(child: CircularProgressIndicator(value: progress.expectedTotalBytes != null ? progress.cumulativeBytesLoaded / (progress.expectedTotalBytes ?? 1) : null)));
                    },
                    errorBuilder: (c, e, s) => const SizedBox(height: 220, child: Center(child: Icon(Icons.broken_image))),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Text(
              mealDetail.strMeal,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 6),
            Text('${mealDetail.strCategory} • ${mealDetail.strArea}'),
            const SizedBox(height: 12),
            const Text('Состојки:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            IngredientList(ingredients: mealDetail.ingredients),
            const SizedBox(height: 12),
            const Text('Инструкции:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 6),
            Text(mealDetail.strInstructions),
            const SizedBox(height: 12),
            if (mealDetail.strYoutube != null && mealDetail.strYoutube!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('YouTube:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('YouTube линк'),
                          content: Text(mealDetail.strYoutube!),
                          actions: [
                            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('ОК'))
                          ],
                        ),
                      );
                    },
                    child: Text(
                      mealDetail.strYoutube!,
                      style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
