import 'dart:async';
import 'dart:io' as io;

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:keuangan/model/Users.dart';

class DBHelper {
  static final DBHelper _instance = new DBHelper.internal();
  DBHelper.internal();

  factory DBHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await setDB();
    return _db;
  }

  setDB() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "keuanganDB");
    var dB = await openDatabase(path, version: 1, onCreate: _onCreate);
    return dB;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE users(id INTEGER PRIMARY KEY, nama TEXT, pin TEXT)");
    print("Table users created");
    await db.execute(
        "CREATE TABLE detail(id_detail INTEGER PRIMARY KEY, tanggal TEXT, kategori TEXT, jumlah INTEGER, keterangan TEXT, status TEXT)");
    print("Table detail created");
  }

  Future<int> saveUser(Users users) async {
    var dbClient = await db;
    int res = await dbClient.insert("users", users.toMap());
    print("Users Inserted");
    return res;
  }

  Future<List<Map>> authUser(String pin) async {
    var dbClient = await db;
    List<Map> res =
        await dbClient.rawQuery("SELECT * FROM users WHERE pin = " + pin);
    return res;
  }
}
