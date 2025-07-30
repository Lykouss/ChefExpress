// lib/screens/favorites_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart'; // Importa o pacote de animação
import '../firestore_service.dart';
import '../widgets/recipe_card.dart';
import '../recipe_model.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(
          child: Text('Faça login para ver os seus favoritos.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Favoritos'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getFavoritesStream(currentUser.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Ocorreu um erro ao carregar os favoritos.'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'Você ainda não tem receitas favoritas.\nToque no coração de uma receita para adicioná-la aqui!',
                textAlign: TextAlign.center,
              ),
            );
          }

          final favoriteDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: favoriteDocs.length,
            itemBuilder: (context, index) {
              final doc = favoriteDocs[index];
              final data = doc.data() as Map<String, dynamic>;

              final recipe = Recipe(
                id: doc.id,
                name: data['name'] ?? 'Nome Indisponível',
                thumbnailUrl: data['thumbnail'] ?? '',
              );
              // --- ANIMAÇÃO APLICADA AQUI ---
              return RecipeCard(recipe: recipe)
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: 0.5, end: 0.0, duration: 600.ms)
                  .moveX(begin: -50, end: 0, delay: 200.ms, duration: 500.ms); // Um efeito extra
            },
          );
        },
      ),
    );
  }
}
