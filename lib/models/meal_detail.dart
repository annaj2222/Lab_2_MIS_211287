class MealDetail {
  final String idMeal;
  final String strMeal;
  final String strCategory;
  final String strArea;
  final String strInstructions;
  final String strMealThumb;
  final String? strYoutube;
  final Map<String, String> ingredients;

  MealDetail({
    required this.idMeal,
    required this.strMeal,
    required this.strCategory,
    required this.strArea,
    required this.strInstructions,
    required this.strMealThumb,
    required this.ingredients,
    this.strYoutube,
  });

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    final Map<String, String> ingr = {};
    for (var i = 1; i <= 20; i++) {
      final ingKey = 'strIngredient$i';
      final measureKey = 'strMeasure$i';
      final ing = (json[ingKey] ?? '').toString().trim();
      final measure = (json[measureKey] ?? '').toString().trim();
      if (ing.isNotEmpty && ing != 'null') {
        ingr[ing] = measure;
      }
    }

    return MealDetail(
      idMeal: json['idMeal'] ?? '',
      strMeal: json['strMeal'] ?? '',
      strCategory: json['strCategory'] ?? '',
      strArea: json['strArea'] ?? '',
      strInstructions: json['strInstructions'] ?? '',
      strMealThumb: json['strMealThumb'] ?? '',
      strYoutube: json['strYoutube'],
      ingredients: ingr,
    );
  }
}
