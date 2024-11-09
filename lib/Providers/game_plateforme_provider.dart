import '../Models/game_plateforme_model.dart';
import '../database_connexion.dart';

class GamePlateformeProvider {
  Future<List<GamePlateforme>> getPlatformsByGameId(int gameId) async {
    final db = await DatabaseConnexion.instance.database;
    try{
      final List<Map<String, dynamic>> maps = await db.query(
        'GamePlateforme',
        where: 'idJeu = ?',
        whereArgs: [gameId],
      );
      return List.generate(maps.length, (i) {
        return GamePlateforme.fromMap(maps[i]);
      });
    } catch(e){
      print('Erreur lors de la récupération des plateformes du jeu : $e');
      return [];
    }
  }

  Future<int> insertGamePlatform(GamePlateforme gamePlatform) async {
    final db = await DatabaseConnexion.instance.database;
    return await db.insert('GamePlateforme', gamePlatform.toMap());
  }

  Future<void> updateGamePlatforms(int gameId, List<int> platformIds) async {
    final db = await DatabaseConnexion.instance.database;

    await db.delete('GamePlateforme', where: 'idJeu = ?', whereArgs: [gameId]);

    for (int platformId in platformIds) {
      await db.insert('GamePlateforme', {
        'idJeu': gameId,
        'idPlateforme': platformId,
      });
    }
  }

  Future<void> deleteGamePlateforme(int gameId) async {
    final db = await DatabaseConnexion.instance.database;
    await db.delete('GamePlateforme', where: 'idJeu = ?', whereArgs: [gameId]);
  }

}
