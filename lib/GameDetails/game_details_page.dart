import 'package:flutter/material.dart';
import '../Models/game_model.dart';
import '../Providers/categorie_provider.dart';
import '../Providers/plateforme_provider.dart';
import '../Providers/game_categorie_provider.dart';
import '../Providers/game_plateforme_provider.dart';
import 'dart:io';

class GameDetailsPage extends StatefulWidget {
  final Game game;

  const GameDetailsPage({super.key, required this.game});

  @override
  _GameDetailsPageState createState() => _GameDetailsPageState();
}

class _GameDetailsPageState extends State<GameDetailsPage> {
  List<String> _categories = [];
  List<String> _platforms = [];

  @override
  void initState() {
    super.initState();
    _loadCategoriesAndPlatforms();
  }

  void _loadCategoriesAndPlatforms() async {
    // Charger les catégories associées au jeu
    final gameCategories = await GameCategorieProvider().getCategoriesByGameId(widget.game.id!);
    final allCategories = await CategorieProvider().getAllCategories();
    setState(() {
      _categories = allCategories
          .where((cat) => gameCategories.map((gCat) => gCat.categoryId).contains(cat.id))
          .map((cat) => cat.name)
          .toList();
    });

    // Charger les plateformes associées au jeu
    final gamePlatforms = await GamePlateformeProvider().getPlatformsByGameId(widget.game.id!);
    final allPlatforms = await PlateformeProvider().getAllPlatforms();
    setState(() {
      _platforms = allPlatforms
          .where((plat) => gamePlatforms.map((gPlat) => gPlat.platformId).contains(plat.id))
          .map((plat) => plat.name)
          .toList();
    });
  }

  Widget _buildImage() {
    return Container(
      width: 150,
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: widget.game.imagePath.startsWith('/data/user')
            ? Image.file(
          File(widget.game.imagePath),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.broken_image, size: 80, color: Colors.grey);
          },
        )
            : Image.asset(
          widget.game.imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.broken_image, size: 80, color: Colors.grey);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du Jeu'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: _buildImage()),
            const SizedBox(height: 20),
            Text(
              widget.game.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Statut: ${widget.game.status}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Heures jouées: ${widget.game.hoursPlayed}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Date d\'ajout: ${widget.game.dateAdded}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            const Text(
              'Catégories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 8.0,
              children: _categories.map((category) => Chip(label: Text(category))).toList(),
            ),
            const SizedBox(height: 20),
            const Text(
              'Plateformes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 8.0,
              children: _platforms.map((platform) => Chip(label: Text(platform))).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
