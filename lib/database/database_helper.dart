import 'package:app_crud_auth_local/model/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'dart:io' as io;


class DbHelper {
  static Database? _db;

  static const String dbUser = "user.db";
  static const String tblUser = "user";
  static const int versionDb = 1;

  static const String userID = "userId";
  static const String userName = "userName";
  static const String email = "email";
  static const String password = "password";

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await iniDb();
    return _db;
  }

  iniDb() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, dbUser);
    var db = await openDatabase(path, version: versionDb, onCreate: _onCreate);
  }

  _onCreate(Database db, int inVersion) async {
    await db.execute("CREATE TABLE $tblUser ("
        " $userID TEXT, "
        " $userName TEXT, "
        " $email TEXT,"
        " $password TEXT, "
        " PRIMARY KEY ($userID)"
        ")");
  }

  Future<int?> saveData(User user) async {
    var dbClient = await db;
    var res = await dbClient?.insert(tblUser, user.toMap());
    return res;
  }

  Future<User?> getLogin(String userId, String password) async {
    var dbClient = await db;
    var res = await dbClient?.rawQuery("SELECT * FROM $tblUser WHERE "
        "$userID = '$userId' AND "
        "$password = '$password'");

    if (res!.isNotEmpty) {
      return User.fromMap(res.first);
    }
    return null;
  }

  Future<int?> updateUser(User user) async {
    var dbClient = await db;
    var result = await dbClient?.update(tblUser, user.toMap(),
        where: "$userID = ?", whereArgs: [user.userId]
    );
    return result;
  }

  Future<int?> deleteUser(String userId) async {
    var dbClient = await db;
    var result = await dbClient?.delete(
        tblUser, whereArgs: [userId], where: "$userID = ?");
    return result;
  }
}