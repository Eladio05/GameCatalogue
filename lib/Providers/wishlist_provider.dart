import 'package:sqflite/sqflite.dart';
import '../Models/wishlist_model.dart';
import '../database_connexion.dart';

class WishlistProvider {
  Future<List<Wishlist>> getWishlist() async {
    final db = await DatabaseConnexion.instance.database;
    try{
      final List<Map<String, dynamic>> maps = await db.query('Wishlist');
      print('Using database path: ${await getDatabasesPath()}');
      return List.generate(maps.length, (i) {
        return Wishlist.fromMap(maps[i]);
      });
    } catch (e) {
      print('Erreur lors de la récupération des jeux de la wishlist : $e');
      return [];
    }
  }

  Future<int> insertWishlist(Wishlist wishlist) async {
    final db = await DatabaseConnexion.instance.database;
    return await db.insert('Wishlist', wishlist.toMap());
  }

  Future<int> deleteWishlist(int id) async {
    final db = await DatabaseConnexion.instance.database;
    return await db.delete('Wishlist', where: 'idWishList = ?', whereArgs: [id]);
  }

  Future<int> updateWishlist(Wishlist wishlist) async {
    final db = await DatabaseConnexion.instance.database;
    return await db.update(
      'Wishlist',
      wishlist.toMap(),
      where: 'idWishList = ?',
      whereArgs: [wishlist.id],
    );
  }
}
