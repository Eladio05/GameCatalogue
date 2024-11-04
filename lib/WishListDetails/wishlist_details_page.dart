import 'package:flutter/material.dart';
import '../Models/wishlist_model.dart';
import '../Providers/categorie_provider.dart';
import '../Providers/plateforme_provider.dart';
import '../Providers/wishlist_categorie_provider.dart';
import '../Providers/wishlist_plateforme_provider.dart';
import 'dart:io';

class WishlistDetailsPage extends StatefulWidget {
  final Wishlist wish;

  const WishlistDetailsPage({super.key, required this.wish});

  @override
  _WishlistDetailsPageState createState() => _WishlistDetailsPageState();
}

class _WishlistDetailsPageState extends State<WishlistDetailsPage> {
  List<String> _categories = [];
  List<String> _platforms = [];

  @override
  void initState() {
    super.initState();
    _loadCategoriesAndPlatforms();
  }

  void _loadCategoriesAndPlatforms() async {
    // Charger les catégories associées à l'élément de la wishlist
    final wishlistCategories = await WishlistCategorieProvider().getCategoriesByWishlistId(widget.wish.id!);
    final allCategories = await CategorieProvider().getAllCategories();
    setState(() {
      _categories = allCategories
          .where((cat) => wishlistCategories.map((wCat) => wCat.categoryId).contains(cat.id))
          .map((cat) => cat.name)
          .toList();
    });

    // Charger les plateformes associées à l'élément de la wishlist
    final wishlistPlatforms = await WishlistPlateformeProvider().getPlatformsByWishlistId(widget.wish.id!);
    final allPlatforms = await PlateformeProvider().getAllPlatforms();
    setState(() {
      _platforms = allPlatforms
          .where((plat) => wishlistPlatforms.map((wPlat) => wPlat.platformId).contains(plat.id))
          .map((plat) => plat.name)
          .toList();
    });
  }

  String _priorityToString(int priority) {
    switch (priority) {
      case 1:
        return 'A joué un jour';
      case 2:
        return 'À découvrir';
      case 3:
        return 'Intéressant';
      case 4:
        return 'Prioritaire';
      case 5:
        return 'À faire absolument';
      default:
        return 'Inconnu';
    }
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
        child: widget.wish.imagePath.startsWith('/data/user')
            ? Image.file(
          File(widget.wish.imagePath),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.broken_image, size: 80, color: Colors.grey);
          },
        )
            : Image.asset(
          widget.wish.imagePath,
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
        title: const Text('Détails de la Wishlist'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: _buildImage()),
            const SizedBox(height: 20),
            Text(
              widget.wish.gameTitle,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Priorité: ${_priorityToString(widget.wish.priority)}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Date d\'ajout: ${widget.wish.dateAdded}',
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
