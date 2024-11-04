import 'package:game_catalog/Models/game_model.dart';
import 'package:game_catalog/database_connexion.dart';
import 'package:sqflite/sqflite.dart';

class GameProvider {
  Future<int> insertGame(Game game) async {
    final db = await DatabaseConnexion.instance.database;
    return await db.insert('Games', game.toMap());
  }

  Future<List<Game>> getGames() async {
    final db = await DatabaseConnexion.instance.database;
    try {
      final List<Map<String, dynamic>> maps = await db.query('Games');
      return List.generate(maps.length, (i) {
        return Game.fromMap(maps[i]);
      });
    } catch (e) {
      print('Erreur lors de la récupération de la liste des jeux : $e');
      return [];
    }
  }

  Future<int> updateGame(Game game) async {
    final db = await DatabaseConnexion.instance.database;
    return await db.update(
      'Games',
      game.toMap(),
      where: 'idGame = ?',
      whereArgs: [game.id],
    );
  }

  Future<int> deleteGame(int id) async {
    final db = await DatabaseConnexion.instance.database;
    return await db.delete(
      'Games',
      where: 'idGame = ?',
      whereArgs: [id],
    );
  }
}
