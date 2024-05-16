import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'db_keys.dart';

class DataBaseServices {
  Future<Database> setDataBase() async {
    final dbPath = await getDatabasesPath();
    var path = join(dbPath, DBKeys.dbName);

    var database =
        await openDatabase(path, version: 1, onCreate: _createDataBase);
    return database;
  }

  Future<void> _createDataBase(Database db, int version) async {
    String registerUserTable =
        "CREATE TABLE ${DBKeys.dbUserTable}(${DBKeys.dbColumnId} INTEGER PRIMARY KEY,${DBKeys.dbUserName} TEXT NOT NULL,${DBKeys.dbUserAge} TEXT NOT NULL,${DBKeys.dbUserGender} TEXT NOT NULL,${DBKeys.dbUserProfileImage} BLOB NOT NULL)";
    String meditationTitleList =
        "CREATE TABLE ${DBKeys.dbMeditationListTable}(${DBKeys.dbColumnId} INTEGER PRIMARY KEY,${DBKeys.dbMeditationTitle} TEXT NOT NULL,${DBKeys.dbMeditationDescription} TEXT NOT NULL,${DBKeys.dbMeditationPlaylistImagePath} BLOB NOT NULL,${DBKeys.dbMeditationCreatedAt} TEXT NOT NULL)";
    String meditationSubTitleList =
        "CREATE TABLE ${DBKeys.dbMeditationSubListTable}(${DBKeys.dbColumnId} INTEGER PRIMARY KEY,${DBKeys.dbMeditationTitleId} INTEGER NOT NULL,${DBKeys.dbMeditationSubTitle} TEXT NOT NULL,${DBKeys.dbMeditationDuration} TEXT NOT NULL,${DBKeys.dbMeditationCreatedAt} TEXT NOT NULL)";

    await db.execute(registerUserTable);
    await db.execute(meditationTitleList);
    await db.execute(meditationSubTitleList);
  }
}
