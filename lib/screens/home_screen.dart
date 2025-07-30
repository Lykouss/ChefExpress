// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import '../api_service.dart';
import '../auth_service.dart';
import 'favorites_screen.dart';
import 'results_screen.dart';
import '../utils/custom_page_route.dart';
import '../widgets/recipe_search_delegate.dart'; // Importa o nosso novo widget

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final AuthService _authService = AuthService();
  late final TabController _tabController;

  final List<String> _categories = [
    'Vegetarian', 'Dessert', 'Chicken', 'Beef', 'Pork', 'Seafood', 'Pasta'
  ];

  String? _selectedCategory;
  List<String> _todosOsIngredientes = [];
  final List<String> _ingredientesSelecionados = [];

  bool _isLoadingIngredients = true;

  final _searchController = TextEditingController();
  List<String> _filteredIngredients = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadIngredients();
    _searchController.addListener(_filterIngredients);
  }

  Future<void> _loadIngredients() async {
    try {
      final ingredients = await ApiService.fetchAllIngredients();
      setState(() {
        _todosOsIngredientes = ingredients;
        _filteredIngredients = ingredients;
        _isLoadingIngredients = false;
      });
    } catch (e) {
      setState(() => _isLoadingIngredients = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar ingredientes: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _filterIngredients() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredIngredients = _todosOsIngredientes.where((ingredient) {
        return ingredient.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _onSearchButtonPressed() {
    if (_tabController.index == 0) {
      if (_ingredientesSelecionados.isNotEmpty) {
        Navigator.push(
          context,
          FadePageRoute(child: ResultsScreen(searchType: SearchType.ingredient, searchValue: _ingredientesSelecionados.first)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, selecione pelo menos um ingrediente.')),
        );
      }
    } else {
      if (_selectedCategory != null) {
        Navigator.push(
          context,
          FadePageRoute(child: ResultsScreen(searchType: SearchType.category, searchValue: _selectedCategory!)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, selecione uma categoria.')),
        );
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chef Express'),
        actions: [
          // --- NOVO BOTÃO DE BUSCA GLOBAL ---
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Buscar por nome',
            onPressed: () {
              // Função nativa do Flutter que abre a nossa interface de busca
              showSearch(
                context: context,
                delegate: RecipeSearchDelegate(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            tooltip: 'Meus Favoritos',
            onPressed: () => Navigator.push(context, FadePageRoute(child: const FavoritesScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () async => await _authService.signOut(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.kitchen), text: 'Por Ingrediente'),
            Tab(icon: Icon(Icons.category), text: 'Por Categoria'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildIngredientsTab(),
          _buildCategoriesTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onSearchButtonPressed,
        label: const Text('BUSCAR RECEITAS'),
        icon: const Icon(Icons.search),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildIngredientsTab() {
    if (_isLoadingIngredients) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Buscar ingrediente...',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 80.0),
            itemCount: _filteredIngredients.length,
            itemBuilder: (context, index) {
              final ingrediente = _filteredIngredients[index];
              return CheckboxListTile(
                title: Text(ingrediente),
                value: _ingredientesSelecionados.contains(ingrediente),
                onChanged: (bool? isSelected) {
                  setState(() {
                    if (isSelected == true) {
                      _ingredientesSelecionados.add(ingrediente);
                    } else {
                      _ingredientesSelecionados.remove(ingrediente);
                    }
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesTab() {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80.0),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        return RadioListTile<String>(
          title: Text(category),
          value: category,
          groupValue: _selectedCategory,
          onChanged: (String? value) {
            setState(() {
              _selectedCategory = value;
            });
          },
        );
      },
    );
  }
}
