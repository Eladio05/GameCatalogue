import 'package:game_catalog/database_connexion.dart';
import '../Models/plateforme_model.dart';

class PlateformeProvider {
  // Insérer une nouvelle plateforme dans la table `Plateforme`
  Future<int> insertPlatform(String platformName) async {
    final db = await DatabaseConnexion.instance.database;
    return await db.insert('Plateforme', {'nomPlateforme': platformName});
  }

  // Récupérer toutes les plateformes avec leurs noms
  Future<List<Plateforme>> getAllPlatforms() async {
    final db = await DatabaseConnexion.instance.database;
    try{
      final List<Map<String, dynamic>> maps = await db.query('Plateforme');

      return List.generate(maps.length, (i) {
        return Plateforme.fromMap(maps[i]);
      });
    } catch(e){
      print('Erreur lors de la récupération des plateformes : $e');
      return [];
    }
  }
}