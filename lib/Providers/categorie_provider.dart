import '../Models/categorie_model.dart';
import '../database_connexion.dart';

class CategorieProvider {
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

  Future<int> insertCategory(String categoryName) async {
    final db = await DatabaseConnexion.instance.database;
    return await db.insert('Catégories', {'nomCategorie': categoryName});
  }
}
