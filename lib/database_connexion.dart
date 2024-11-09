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
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "games_database.db");

    if (!await databaseExists(path)) {
      ByteData data = await rootBundle.load("assets/database/gamecatalog.db");
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes);
    }
    return openDatabase(path);
  }
}
