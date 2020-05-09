
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static const String  TABLE_AYAH_INFO = 'list_ayah';
  static String listOfAyahSql = 
    'CREATE TABLE '+ TABLE_AYAH_INFO +'(id TEXT PRIMARY KEY, numberOfSurah INTEGER, number INTEGER, numberInSurah INTEGER, text TEXT, page INTEGER, sajda TEXT, identifier TEXT, language TEXT, englishName TEXT, format TEXT, type TEXT, direction TEXT)';

  static const String  TABLE_SURAH_INFO = 'list_surah';
  static String listOfSurahSql = 
    'CREATE TABLE '+ TABLE_SURAH_INFO +'(id TEXT PRIMARY KEY, number INTEGER, name TEXT, englishName TEXT, englishNameTranslation TEXT, numberOfAyahs INTEGER, revelationType TEXT)';

  static const String  TABLE_FORMAT_INFO = 'list_format';
  static String listOfFormatSql = 
    'CREATE TABLE '+ TABLE_FORMAT_INFO +'(id TEXT PRIMARY KEY, identifier TEXT, language TEXT, name TEXT, englishName TEXT, format TEXT, type TEXT, direction TEXT)';


  static Future<Database> database() async{
 
   final dbPath = await sql.getDatabasesPath();

    return sql.openDatabase(
      path.join(dbPath, 'quran.db'),
      onCreate: (db, version){
                Batch batch = db.batch();
                batch.execute(listOfSurahSql);
                batch.execute(listOfFormatSql);
                batch.execute(listOfAyahSql);  
                batch.commit().then((_){
                  return;
                });     
      }, 
      version: 1 
      );

  }

  static Future<void> clearTable(String table, {String where, List<String> whereArgs}) async{
    print("deleting");
    final db = await DBHelper.database();
    if(where != null && whereArgs != []) db.delete(table, where: where, whereArgs: whereArgs);
      db.delete(table);
  }
 
  static Future<void> insert(String table, Map<String, Object>data) async {
    print("inserting");
    final db = await DBHelper.database();
    Future<int> line = db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    line.then((onValue) => print('line - ${onValue.toString()}'));
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    print('getData db data');
    final db = await DBHelper.database();
    return db.query(table);
  }

  static Future<List<Map<String, dynamic>>> getAyah(String table, int numberOfSurah, String identifier) async {
    final db = await DBHelper.database();
    print('getAyah db data');
    print('${numberOfSurah.toString()}');
    print(numberOfSurah.toString());
    return db.query(table, where: '"numberOfSurah" = ? and "identifier" = ?', whereArgs: [ '${numberOfSurah.toString()}' , '$identifier']);
  }
    

}
    
    