import 'package:game_catalog/database_connexion.dart';
import '../Models/game_plateforme_model.dart';

class GamePlateformeProvider {
  // Récupérer toutes les plateformes d'un jeu spécifique
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

  // Insérer une nouvelle plateforme pour un jeu
  Future<int> insertGamePlatform(GamePlateforme gamePlatform) async {
    final db = await DatabaseConnexion.instance.database;
    return await db.insert('GamePlateforme', gamePlatform.toMap());
  }

  // Mettre à jour les plateformes d'un jeu
  Future<void> updateGamePlatforms(int gameId, List<int> platformIds) async {
    final db = await DatabaseConnexion.instance.database;

    // Supprimer les associations existantes
    await db.delete('GamePlateforme', where: 'idJeu = ?', whereArgs: [gameId]);

    // Ajouter les nouvelles associations
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
