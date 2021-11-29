import 'package:food_rating_app/data/models/restaurant.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal() {
    _instance = this;
  }

  factory DatabaseHelper() => _instance ?? DatabaseHelper._internal();

  static const String _tableName = 'favorite';

  Future<Database> _initializeDb() async {
    final path = await getDatabasesPath();
    final db = openDatabase(
      join(path, 'favorite_db.db'),
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $_tableName (
          id TEXT PRIMARY KEY,
          name TEXT,
          description TEXT,
          pictureId TEXT,
          city TEXT,
          rating DOUBLE
        )''');
      },
      version: 1,
    );

    return db;
  }

  Future<Database?> get database async {
    _database ??= await _initializeDb();
    return _database;
  }

  /// Insert favorite
  Future<void> insertFavorite(Item restaurant) async {
    final Database? db = await database;
    await db!.insert(_tableName, restaurant.toMap());
  }

  /// Get all favorite
  Future<List<Item>> getFavorites() async {
    final Database? db = await database;
    List<Map<String, dynamic>> results = await db!.query(_tableName);

    return results.map((res) => Item.fromMapMinimal(res)).toList();
  }

  /// Get favorite by id
  Future<Map> getFavoriteById(String id) async {
    final Database? db = await database;
    List<Map<String, dynamic>> results = await db!.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {};
    }
  }

  /// Delete all favorite
  Future<void> deleteAllFavorite() async {
    final Database? db = await database;
    await db!.delete(_tableName);
  }

  /// Delete favorite
  Future<void> deleteFavorite(String id) async {
    final Database? db = await database;
    await db!.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
