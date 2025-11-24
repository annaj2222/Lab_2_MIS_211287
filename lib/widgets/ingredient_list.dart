import 'package:flutter/material.dart';

class IngredientList extends StatelessWidget {
  final Map<String, String> ingredients;
  const IngredientList({super.key, required this.ingredients});

  @override
  Widget build(BuildContext context) {
    if (ingredients.isEmpty) {
      return const Text('Нема податоци за состојки');
    }
    final entries = ingredients.entries.toList();
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: entries.length,
      separatorBuilder: (_, __) => const Divider(height: 4),
      itemBuilder: (ctx, idx) {
        final item = entries[idx];
        final measure = item.value.isNotEmpty ? item.value : '-';
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(item.key)),
            const SizedBox(width: 12),
            Text(measure, style: const TextStyle(color: Colors.grey)),
          ],
        );
      },
    );
  }
}
