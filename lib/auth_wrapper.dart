// lib/auth_wrapper.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder<User?>(
      // Ouve as mudanças no estado de autenticação
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // Se estiver a carregar a informação, mostra um ecrã de loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        // Se o utilizador estiver logado (snapshot tem dados)
        if (snapshot.hasData) {
          // Mostra a HomeScreen
          return const HomeScreen();
        }

        // Se o utilizador não estiver logado
        // Mostra a LoginScreen
        return const LoginScreen();
      },
    );
  }
}
