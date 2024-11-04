import 'package:game_catalog/database_connexion.dart';
import '../Models/wishlist_categorie_model.dart';

class WishlistCategorieProvider {
  // Récupérer toutes les catégories associées à une wishlist spécifique
  Future<List<WishlistCategorie>> getCategoriesByWishlistId(int wishlistId) async {
    final db = await DatabaseConnexion.instance.database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'WishlistGenre',
        where: 'idWishList = ?',
        whereArgs: [wishlistId],
      );

      return List.generate(maps.length, (i) {
        return WishlistCategorie.fromMap(maps[i]);
      });
    } catch (e) {
      print('Erreur lors de la récupération des catégories du jeu souhaité : $e');
      return [];
    }
  }

  // Insérer une nouvelle catégorie pour une wishlist
  Future<int> insertWishlistCategory(WishlistCategorie wishlistCategory) async {
    final db = await DatabaseConnexion.instance.database;
    return await db.insert('WishlistGenre', wishlistCategory.toMap());
  }

  // Mettre à jour les catégories d'une wishlist
  Future<void> updateWishlistCategories(int wishlistId, List<int> categoryIds) async {
    final db = await DatabaseConnexion.instance.database;

    // Supprimer les associations existantes
    await db.delete('WishlistGenre', where: 'idWishList = ?', whereArgs: [wishlistId]);

    // Ajouter les nouvelles associations
    for (int categoryId in categoryIds) {
      await db.insert('WishlistGenre', {
        'idWishList': wishlistId,
        'idCategorie': categoryId,
      });
    }
  }

  Future<void> deleteWishlistCategorie(int wishlistId) async {
    final db = await DatabaseConnexion.instance.database;
    await db.delete('WishlistGenre', where: 'idWishList = ?', whereArgs: [wishlistId]);
  }
}
