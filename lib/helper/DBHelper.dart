import 'dart:async';
import 'dart:io' as io;

import 'package:keuangan/model/Tanggal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:keuangan/model/Users.dart';
import 'package:keuangan/model/Detail.dart';

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
        "CREATE TABLE tanggal(id_tanggal INTEGER PRIMARY KEY, tanggal INTEGER, bulan INTEGER, tahun INTEGER, time INTEGER)");
    print("Table tanggal created");
    await db.execute(
        "CREATE TABLE detail(id_detail INTEGER PRIMARY KEY, id_user INTEGER, id_tanggal INTEGER, kategori TEXT, jumlah INTEGER, keterangan TEXT, kode INTEGER)");
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

  Future<int> saveDetail(Detail detail) async {
    var dbClient = await db;

    int res = await dbClient.insert("detail", detail.toMap());
    print("Detail Inserted");
    return res;
  }

  Future<int> saveTanggal(Tanggal tanggal) async {
    var dbClient = await db;

    int tRes = await dbClient.insert("tanggal", tanggal.toMap());
    print("Detail Inserted");
    return tRes;
  }

  Future<List<Map>> checkTanggal(DateTime date) async {
    var dbClient = await db;

    var data = await dbClient.rawQuery(
      "SELECT * FROM tanggal WHERE tanggal = ${date.day} AND bulan = ${date.month} AND tahun = ${date.year}",
    );

    print(data);

    return data;
  }

  Future<List<Map>> select(String sql) async {
    var dbClient = await db;
    List<Map> res = await dbClient.rawQuery(sql);
    return res;
  }
}
