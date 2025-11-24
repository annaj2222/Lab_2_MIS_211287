import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/api_service.dart';
import 'screens/categories_screen.dart';

void main() {
  runApp(const MealApp());
}

class MealApp extends StatelessWidget {
  const MealApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<ApiService>(
      create: (_) => ApiService(),
      child: MaterialApp(
        title: 'MealDB Recipes',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        home: const CategoriesScreen(),
      ),
    );
  }
}
