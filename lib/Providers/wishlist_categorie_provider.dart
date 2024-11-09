import '../Models/wishlist_categorie_model.dart';
import '../database_connexion.dart';

class WishlistCategorieProvider {
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

  Future<int> insertWishlistCategory(WishlistCategorie wishlistCategory) async {
    final db = await DatabaseConnexion.instance.database;
    return await db.insert('WishlistGenre', wishlistCategory.toMap());
  }

  Future<void> updateWishlistCategories(int wishlistId, List<int> categoryIds) async {
    final db = await DatabaseConnexion.instance.database;
    await db.delete('WishlistGenre', where: 'idWishList = ?', whereArgs: [wishlistId]);

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
