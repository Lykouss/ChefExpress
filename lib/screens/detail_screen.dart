// lib/screens/detail_screen.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart'; // Importa o pacote para abrir links
import '../api_service.dart';
import '../firestore_service.dart';
import '../recipe_model.dart';

class DetailScreen extends StatefulWidget {
  final String recipeId;

  const DetailScreen({super.key, required this.recipeId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  bool _isFavorite = false;
  Recipe? _currentRecipe;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  void _checkIfFavorite() async {
    if (_currentUser != null) {
      final isFav = await _firestoreService.isFavorite(_currentUser.uid, widget.recipeId);
      if (mounted) {
        setState(() => _isFavorite = isFav);
      }
    }
  }

  void _toggleFavorite() async {
    if (_currentUser == null || _currentRecipe == null) return;

    setState(() => _isFavorite = !_isFavorite);

    if (_isFavorite) {
      await _firestoreService.addFavorite(
        _currentUser.uid,
        _currentRecipe!.id,
        _currentRecipe!.name,
        _currentRecipe!.thumbnailUrl,
      );
    } else {
      await _firestoreService.removeFavorite(_currentUser.uid, widget.recipeId);
    }
  }

  // --- NOVA FUNÇÃO PARA ABRIR O VÍDEO ---
  void _launchYouTubeUrl() async {
    if (_currentRecipe?.youtubeUrl != null && _currentRecipe!.youtubeUrl!.isNotEmpty) {
      final uri = Uri.parse(_currentRecipe!.youtubeUrl!);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        // Mostra uma mensagem se não conseguir abrir o link
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível abrir o vídeo.'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Recipe>(
        future: ApiService.fetchRecipeDetailsById(widget.recipeId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Nenhum detalhe encontrado.'));
          }

          _currentRecipe = snapshot.data!;
          final recipe = _currentRecipe!;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                stretch: true,
                expandedHeight: 300.0,
                pinned: true,
                actions: [
                  IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? Colors.red : Colors.white,
                    ),
                    onPressed: _toggleFavorite,
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    recipe.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  centerTitle: true,
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: recipe.thumbnailUrl,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => const Center(child: Icon(Icons.broken_image)),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.2),
                              Colors.black.withOpacity(0.6),
                            ],
                            stops: const [0.5, 0.8, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- NOVA SEÇÃO: TAGS E BOTÃO DE VÍDEO ---
                      Wrap(
                        spacing: 8.0,
                        children: [
                          if (recipe.category != null && recipe.category!.isNotEmpty)
                            Chip(label: Text(recipe.category!), avatar: const Icon(Icons.category_outlined)),
                          if (recipe.area != null && recipe.area!.isNotEmpty)
                            Chip(label: Text(recipe.area!), avatar: const Icon(Icons.public_outlined)),
                        ],
                      ),
                      if (recipe.youtubeUrl != null && recipe.youtubeUrl!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: _launchYouTubeUrl,
                            icon: const Icon(Icons.play_circle_fill),
                            label: const Text('Ver Vídeo da Receita'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(250, 48), // Tamanho fixo para o botão
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      // --- FIM DA NOVA SEÇÃO ---

                      const Text('Ingredientes', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      for (var ingredient in recipe.ingredients)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text('• $ingredient'),
                        ),
                      const SizedBox(height: 24),
                      const Text('Modo de Preparo', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(recipe.instructions ?? 'Instruções não disponíveis.', textAlign: TextAlign.justify),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
