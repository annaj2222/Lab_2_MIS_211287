import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_lab/providers/favorite_provider.dart';
import 'package:second_lab/services/notification_service.dart';
import 'services/api_service.dart';
import 'screens/categories_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await NotificationService.initialize(timeZone: 'Europe/Skopje');

  await NotificationService.scheduleDailyReminder(
    id: 1,
    hour: 18,
    minute: 0,
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => ApiService()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
      ],
      child: const MealApp(),
    ),
  );
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
