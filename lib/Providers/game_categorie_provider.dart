import 'package:sqflite/sqflite.dart';
import 'package:game_catalog/database_connexion.dart';
import '../Models/game_categorie_model.dart';

class GameCategorieProvider {
  // Récupérer toutes les catégories avec leurs noms
  Future<List<GameCategorie>> getAllCategories() async {
    final db = await DatabaseConnexion.instance.database;
    try {
      final List<Map<String, dynamic>> maps = await db.query('Categories');
      return List.generate(maps.length, (i) {
        return GameCategorie(
          gameId: maps[i]['idCategorie'],
          categoryId: maps[i]['idCategorie'],
        );
      });

    } catch(e){
      print('Erreur lors de la récupération des categories du jeu : $e');
      return [];
    }
  }

  Future<int> insertGameCategory(GameCategorie gameCategory) async {
    final db = await DatabaseConnexion.instance.database;
    return await db.insert('GameGenre', gameCategory.toMap());
  }

  Future<List<GameCategorie>> getCategoriesByGameId(int gameId) async {
    final db = await DatabaseConnexion.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'GameGenre',
      where: 'idJeu = ?',
      whereArgs: [gameId],
    );

    return List.generate(maps.length, (i) {
      return GameCategorie.fromMap(maps[i]);
    });
  }

  Future<int> updateGameCategory(GameCategorie gameCategorie) async {
    final db = await DatabaseConnexion.instance.database;
    return await db.update(
      'GameGenre',
      gameCategorie.toMap(),
      where: 'idJeu = ? AND idGenre = ?',
      whereArgs: [gameCategorie.gameId, gameCategorie.categoryId],
    );
  }

  Future<int> deleteGameCategory(int gameId, int categoryId) async {
    final db = await DatabaseConnexion.instance.database;
    return await db.delete(
      'GameGenre',
      where: 'idJeu = ? AND idGenre = ?',
      whereArgs: [gameId, categoryId],
    );
  }

  // Mettre à jour les catégories d'un jeu
  Future<void> updateGameCategories(int gameId, List<int> categoryIds) async {
    final db = await DatabaseConnexion.instance.database;

    // Supprimer les associations existantes
    await db.delete('GameGenre', where: 'idJeu = ?', whereArgs: [gameId]);

    // Ajouter les nouvelles associations
    for (int categoryId in categoryIds) {
      await db.insert('GameGenre', {
        'idJeu': gameId,
        'idGenre': categoryId,
      });
    }
  }

  Future<void> deleteGameCategorie(int gameId) async {
    final db = await DatabaseConnexion.instance.database;
    await db.delete('GameGenre', where: 'idJeu = ?', whereArgs: [gameId]);
  }

}
