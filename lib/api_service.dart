// lib/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'recipe_model.dart';

class ApiService {
  static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1/';

  // --- NOVA FUNÇÃO ---
  // Função para buscar receitas pelo nome
  static Future<List<Recipe>> fetchRecipesByName(String name) async {
    final String url = '${_baseUrl}search.php?s=$name';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        // A API pode retornar 'null' se não encontrar nada. Tratamos isso aqui.
        final List<dynamic>? meals = data['meals'];
        if (meals == null) {
          return []; // Retorna uma lista vazia se não houver receitas
        }
        return meals.map((mealJson) => Recipe.fromJson(mealJson)).toList();
      } else {
        throw Exception('Falha ao buscar receitas');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
  
  // Função para buscar a lista de todos os ingredientes
  static Future<List<String>> fetchAllIngredients() async {
    const String url = '${_baseUrl}list.php?i=list';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> ingredientsData = data['meals'];
        return ingredientsData.map((ing) => ing['strIngredient'] as String).toList();
      } else {
        throw Exception('Falha ao carregar a lista de ingredientes');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Função para buscar receitas por UMA categoria
  static Future<List<Recipe>> fetchRecipesByCategory(String category) async {
    final String url = '${_baseUrl}filter.php?c=$category';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> meals = data['meals'] ?? [];
        return meals.map((mealJson) => Recipe.fromJson(mealJson)).toList();
      } else {
        throw Exception('Falha ao carregar receitas por categoria');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Função para buscar receitas por UM ingrediente principal
  static Future<List<Recipe>> fetchRecipesByIngredient(String ingredient) async {
    final String url = '${_baseUrl}filter.php?i=$ingredient';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> meals = data['meals'] ?? [];
        return meals.map((mealJson) => Recipe.fromJson(mealJson)).toList();
      } else {
        throw Exception('Falha ao carregar receitas por ingrediente');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Função para buscar detalhes de uma receita
  static Future<Recipe> fetchRecipeDetailsById(String recipeId) async {
    final String url = '${_baseUrl}lookup.php?i=$recipeId';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final mealJson = data['meals'][0];
        return Recipe.fromJson(mealJson);
      } else {
        throw Exception('Falha ao carregar detalhes da receita');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}
