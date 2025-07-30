// lib/widgets/recipe_search_delegate.dart

import 'package:flutter/material.dart';
import '../api_service.dart';
import '../recipe_model.dart';
import 'recipe_card.dart';

class RecipeSearchDelegate extends SearchDelegate {
  // Personaliza o texto de dica na barra de busca
  @override
  String get searchFieldLabel => 'Procurar pelo nome da receita...';

  // Define as ações da AppBar (ex: botão de limpar)
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; // Limpa o texto da busca
        },
      ),
    ];
  }

  // Define o ícone à esquerda da AppBar (ex: botão de voltar)
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Fecha a interface de busca
      },
    );
  }

  // Chamado quando o utilizador submete a busca (pressiona "Enter")
  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text('Digite algo para pesquisar.'));
    }
    // Usa um FutureBuilder para buscar e exibir os resultados
    return FutureBuilder<List<Recipe>>(
      future: ApiService.fetchRecipesByName(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Ocorreu um erro na busca.'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Nenhuma receita encontrada para "$query"'));
        }

        final recipes = snapshot.data!;
        return ListView.builder(
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            return RecipeCard(recipe: recipes[index]);
          },
        );
      },
    );
  }

  // Chamado a cada letra digitada para mostrar sugestões (vamos re-utilizar os resultados)
  @override
  Widget buildSuggestions(BuildContext context) {
    // Para simplificar, vamos mostrar os resultados diretamente enquanto o utilizador digita.
    return buildResults(context);
  }
}
