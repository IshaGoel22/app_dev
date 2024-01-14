import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
// import 'package:flutter/material.dart';

class DbHelper {
  static Future<sql.Database> database() async {
    //path of database
    var dbPth = await sql.getDatabasesPath();
    //path and name
    var datab = path.join(dbPth, 'data.db');

    // open the database
    return sql.openDatabase(datab, version: 1,
        onCreate: (sql.Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          //user_places() name given to table , id , titlr image are in table with id as primary key (only one)
          //id title names change according to our key in app
          //TEXT,INTEGER,REAL -- can be of any type
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT,loc_lat REAL,loc_lng REAL,address TEXT)');
    });
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final sqlDb = await database();
    //to insert data in table
    //replace the data in table if we pass some new data to same id
    sqlDb.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final sqlDb = await database();
    //to get data from table
    return sqlDb.query(table);
  }
}
