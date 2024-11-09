import '../Models/wishlist_plateforme_model.dart';
import '../database_connexion.dart';

class WishlistPlateformeProvider {
  Future<List<WishlistPlateforme>> getPlatformsByWishlistId(int wishlistId) async {
    final db = await DatabaseConnexion.instance.database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'WishlistPlateforme',
        where: 'idWishList = ?',
        whereArgs: [wishlistId],
      );
      return List.generate(maps.length, (i) {
        return WishlistPlateforme.fromMap(maps[i]);
      });
    } catch (e) {
      print('Erreur lors de la récupération des plateformes du jeu souhaité : $e');
      return [];
    }
  }

  Future<int> insertWishlistPlatform(WishlistPlateforme wishlistPlatform) async {
    final db = await DatabaseConnexion.instance.database;
    return await db.insert('WishlistPlateforme', wishlistPlatform.toMap());
  }

  Future<void> updateWishlistPlatforms(int wishlistId, List<int> platformIds) async {
    final db = await DatabaseConnexion.instance.database;

    await db.delete('WishlistPlateforme', where: 'idWishList = ?', whereArgs: [wishlistId]);

    for (int platformId in platformIds) {
      await db.insert('WishlistPlateforme', {
        'idWishList': wishlistId,
        'idPlateforme': platformId,
      });
    }
  }

  Future<void> deleteWishlistPlateforme(int wishlistId) async {
    final db = await DatabaseConnexion.instance.database;
    await db.delete('WishlistPlateforme', where: 'idWishList = ?', whereArgs: [wishlistId]);
  }
}
