// lib/screens/results_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart'; // Importa o pacote de animação
import '../api_service.dart';
import '../recipe_model.dart';
import '../widgets/recipe_card.dart';

enum SearchType { ingredient, category, name }

class ResultsScreen extends StatefulWidget {
  final SearchType searchType;
  final String searchValue;

  const ResultsScreen({
    super.key,
    required this.searchType,
    required this.searchValue
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  late Future<List<Recipe>> _recipesFuture;

  @override
  void initState() {
    super.initState();
    _recipesFuture = _fetchRecipes();
  }

  Future<List<Recipe>> _fetchRecipes() {
    switch (widget.searchType) {
      case SearchType.ingredient:
        return ApiService.fetchRecipesByIngredient(widget.searchValue);
      case SearchType.category:
        return ApiService.fetchRecipesByCategory(widget.searchValue);
      case SearchType.name:
        return ApiService.fetchRecipesByName(widget.searchValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultados para "${widget.searchValue}"'),
      ),
      body: FutureBuilder<List<Recipe>>(
        future: _recipesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao buscar receitas: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma receita encontrada.'));
          }

          final recipes = snapshot.data!;
          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              // --- ANIMAÇÃO APLICADA AQUI ---
              return RecipeCard(recipe: recipes[index])
                  .animate() // Inicia a animação
                  .fadeIn(duration: 600.ms, delay: (100 * index).ms) // Efeito de fade
                  .slideY(begin: 0.5, end: 0.0, duration: 600.ms); // Efeito de deslizar de baixo para cima
            },
          );
        },
      ),
    );
  }
}
