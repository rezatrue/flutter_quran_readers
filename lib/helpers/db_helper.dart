
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static const String  TABLE_SURAH_INFO = 'list_surah';
  static String listOfSurahSql = 
    'CREATE TABLE '+ TABLE_SURAH_INFO +'(id TEXT PRIMARY KEY, number INTEGER, name TEXT, englishName TEXT, englishNameTranslation TEXT, numberOfAyahs INTEGER, revelationType TEXT)';

  static Future<Database> database() async{

   final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'quran.db'),
      onCreate: (db, version){
        return db.execute(listOfSurahSql);
      }, 
      version: 1 
      );
  }

  static Future<void> clearTable(String table) async{
    print("deleting");
    final db = await DBHelper.database();
      db.delete(table);
  }
  static Future<void> insert(String table, Map<String, Object>data) async {
    print("inserting");
    final db = await DBHelper.database();
    db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    print('getData db data');
    final db = await DBHelper.database();
    return db.query(table);
  }

}