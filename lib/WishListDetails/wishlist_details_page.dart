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
    final wishlistCategories = await WishlistCategorieProvider().getCategoriesByWishlistId(widget.wish.id!);
    final allCategories = await CategorieProvider().getAllCategories();
    setState(() {
      _categories = allCategories
          .where((cat) => wishlistCategories.map((wCat) => wCat.categoryId).contains(cat.id))
          .map((cat) => cat.name)
          .toList();
    });
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
        return 'À jouer un jour';
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
        border: Border.all(color: const Color.fromARGB(255, 128, 0, 128)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: widget.wish.imagePath.startsWith('/data/user')
            ? Image.file(
          File(widget.wish.imagePath),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.broken_image, size: 80, color: Colors.purpleAccent);
          },
        )
            : Image.asset(
          widget.wish.imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.broken_image, size: 80, color: Colors.purpleAccent);
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
        backgroundColor: const Color.fromARGB(255, 128, 0, 128),
        title: const Text(
          'Détails de la Wishlist',
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
              widget.wish.gameTitle,
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
              'Priorité: ${_priorityToString(widget.wish.priority)}',
              style: const TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 128, 0, 128),
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Date d'ajout: ${widget.wish.dateAdded}",
              style: const TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 128, 0, 128),
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
                  backgroundColor: const Color.fromARGB(255, 128, 0, 128),
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
                  backgroundColor: const Color.fromARGB(255, 128, 0, 128),
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
