import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseConnexion {
  static final DatabaseConnexion instance = DatabaseConnexion._privateConstructor();
  static Database? _database;

  DatabaseConnexion._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    // Si la base de données n'existe pas encore, on la copie depuis les assets
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Obtenir le chemin du répertoire des documents
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "games_database.db");

    // Vérifier si la base de données existe déjà dans le répertoire de documents
    if (!await databaseExists(path)) {
      // Copier la base de données depuis les assets vers le répertoire des documents
      ByteData data = await rootBundle.load("assets/database/gamecatalog.db");
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Écrire le fichier de base de données dans le répertoire des documents
      await File(path).writeAsBytes(bytes);
    }

    // Ouvrir la base de données
    return openDatabase(path);
  }
}
