import 'package:sqflite/sqflite.dart';
import 'package:game_catalog/database_connexion.dart';
import '../Models/categorie_model.dart';

class CategorieProvider {
  // Récupérer toutes les catégories avec leurs noms
  Future<List<Categorie>> getAllCategories() async {
    final db = await DatabaseConnexion.instance.database;
    try{
      final List<Map<String, dynamic>> maps = await db.query('Catégories');
      return List.generate(maps.length, (i) {
        return Categorie.fromMap(maps[i]);
      });
    } catch(e){
      print('Erreur lors de la récupération des categories: $e');
      return [];
    }
  }

  // Insérer une nouvelle catégorie dans la table `Catégories`
  Future<int> insertCategory(String categoryName) async {
    final db = await DatabaseConnexion.instance.database;
    return await db.insert('Catégories', {'nomCategorie': categoryName});
  }
}
