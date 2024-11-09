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
    final gameCategories = await GameCategorieProvider().getCategoriesByGameId(widget.game.id!);
    final allCategories = await CategorieProvider().getAllCategories();
    setState(() {
      _categories = allCategories
          .where((cat) => gameCategories.map((gCat) => gCat.categoryId).contains(cat.id))
          .map((cat) => cat.name)
          .toList();
    });

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
        border: Border.all(color: const Color.fromARGB(255, 255, 0, 0)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: widget.game.imagePath.startsWith('/data/user')
            ? Image.file(
          File(widget.game.imagePath),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.broken_image, size: 80, color: Colors.redAccent);
          },
        )
            : Image.asset(
          widget.game.imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.broken_image, size: 80, color: Colors.redAccent);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 26, 26, 29),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 0, 0),
        title: const Text(
          'Détails du Jeu',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: _buildImage()),
            const SizedBox(height: 20),
            Text(
              widget.game.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Statut: ${widget.game.status}',
              style: const TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 255, 0, 0),
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Heures jouées: ${widget.game.hoursPlayed}',
              style: const TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 255, 0, 0),
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Date d\'ajout: ${widget.game.dateAdded}',
              style: const TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 255, 0, 0),
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Catégories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 8.0,
                children: _categories.map((category) => Chip(
                  label: Text(
                    category,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                )).toList(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Plateformes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 8.0,
                children: _platforms.map((platform) => Chip(
                  label: Text(
                    platform,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
