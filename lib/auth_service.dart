// lib/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Instância do Firebase Auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Método para registar um novo utilizador com e-mail e senha
  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      // Exibe erros de forma amigável
      print('Erro no registo: ${e.message}');
      return null;
    }
  }

  // Método para fazer login com e-mail e senha
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      print('Erro no login: ${e.message}');
      return null;
    }
  }

  // Método para fazer logout
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Stream para ouvir as mudanças no estado de autenticação (logado/deslogado)
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
