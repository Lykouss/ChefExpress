// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app_theme.dart'; // Importa o nosso novo tema
import 'auth_wrapper.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geladeira Inteligente',
      debugShowCheckedModeBanner: false, // Remove a fita de "Debug"
      
      // --- APLICAÇÃO DO TEMA GLOBAL ---
      theme: AppTheme.theme, 
      
      home: const AuthWrapper(),
    );
  }
}
