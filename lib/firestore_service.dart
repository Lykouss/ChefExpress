// lib/firestore_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- FUNÇÃO MODIFICADA ---
  // Agora, ao adicionar, guardamos também o nome e a foto para um carregamento rápido.
  Future<void> addFavorite(String userId, String recipeId, String recipeName, String recipeThumb) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(recipeId)
          .set({
            'name': recipeName,
            'thumbnail': recipeThumb,
            'favoritedAt': Timestamp.now(),
          });
    } catch (e) {
      print('Erro ao adicionar favorito: $e');
    }
  }

  // Função para remover um favorito (sem alterações)
  Future<void> removeFavorite(String userId, String recipeId) async {
    try {
      await _db.collection('users').doc(userId).collection('favorites').doc(recipeId).delete();
    } catch (e) {
      print('Erro ao remover favorito: $e');
    }
  }

  // Função para verificar se é favorito (sem alterações)
  Future<bool> isFavorite(String userId, String recipeId) async {
    try {
      final doc = await _db.collection('users').doc(userId).collection('favorites').doc(recipeId).get();
      return doc.exists;
    } catch (e) {
      print('Erro ao verificar favorito: $e');
      return false;
    }
  }

  // --- NOVA FUNÇÃO ---
  // Retorna um "stream", uma corrente de dados em tempo real, dos favoritos do utilizador.
  Stream<QuerySnapshot> getFavoritesStream(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .orderBy('favoritedAt', descending: true) // Ordena pelos mais recentes
        .snapshots();
  }
}
