// lib/recipe_model.dart

class Recipe {
  final String id;
  final String name;
  final String thumbnailUrl;
  final String? instructions;
  final List<String> ingredients;
  
  // --- NOVOS CAMPOS ---
  final String? category;   // Categoria (ex: "Dessert")
  final String? area;       // Origem (ex: "Italian")
  final String? youtubeUrl; // Link do vídeo no YouTube

  Recipe({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
    this.instructions,
    this.ingredients = const [],
    this.category,
    this.area,
    this.youtubeUrl,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    List<String> ingredientsList = [];
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];

      if (ingredient != null && ingredient.isNotEmpty && ingredient.trim().isNotEmpty) {
        ingredientsList.add('$measure $ingredient');
      }
    }

    return Recipe(
      id: json['idMeal'],
      name: json['strMeal'],
      thumbnailUrl: json['strMealThumb'],
      instructions: json['strInstructions'],
      ingredients: ingredientsList,
      
      // Mapeamento dos novos campos
      category: json['strCategory'],
      area: json['strArea'],
      youtubeUrl: json['strYoutube'],
    );
  }
}
