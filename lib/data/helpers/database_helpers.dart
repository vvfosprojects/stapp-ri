import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:stapp_ri/domain/values/values.dart';
import './db_values.dart';

// singleton class to manage the database
class DatabaseHelper {
  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = DBValues.dbName;
  // Increment this version when you need to change the schema.
  static final _databaseVersion = DBValues.dbVersion;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE IF NOT EXISTS ${DBValues.tableOperations} (
                ${Values.opId} INTEGER PRIMARY KEY AUTOINCREMENT,
                ${Values.opTitle} TEXT NOT NULL,
                ${Values.opDescription} TEXT NOT NULL,
                ${Values.opDate} TEXT NOT NULL,
                ${Values.opStatus} TEXT NOT NULL,
                ${Values.opCoordinates} TEXT
              )
              ''');

    await db.execute('''
              CREATE TABLE IF NOT EXISTS ${DBValues.tableMedia} (
                ${Values.mediaId} INTEGER PRIMARY KEY AUTOINCREMENT,
                ${Values.mediaOpId} INTEGER NOT NULL,
                ${Values.mediaName} TEXT NOT NULL,
                ${Values.mediaPath} TEXT NOT NULL,
                ${Values.mediaType} TEXT NOT NULL,
                CONSTRAINT fk_opId
                FOREIGN KEY (${Values.mediaId})
                REFERENCES ${DBValues.tableOperations}(${Values.opId})
              )
              ''');
  }
}