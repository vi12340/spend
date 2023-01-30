import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spend/models/budget.dart';
import 'package:spend/models/category.dart';
import 'package:spend/models/manage.dart';
import 'package:spend/models/manageCategory.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  Database? _db;

  Future<Database?> get db async{
    if(_db != null){
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async{
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = await join(documentDirectory.path, 'spend.db');
    return await openDatabase(path, version: 1, onCreate: _onCreat);
  }

  _onCreat(Database db, int version) async{
    await db.execute('CREATE TABLE budget(id INTEGER PRIMARY KEY AUTOINCREMENT, price INTEGER, dateTime DATE)');
    await db.execute('CREATE TABLE category(idCategory INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT,icon TEXT, color TEXT)');
    await db.execute('CREATE TABLE manage(id INTEGER PRIMARY KEY AUTOINCREMENT, idCategory INTEGER, price INTEGER, type TEXT,dateTime DATE, comment TEXT, FOREIGN KEY (idCategory) REFERENCES category(idCategory))');

  }

  Future<List<budgetModel>> getBudget() async{
    var dbClient = await db;
    List<Map<String, dynamic>> queryResual = await dbClient!.query('budget');
    return queryResual.map((e) => budgetModel.fromMap(e)).toList();
  }

  Future<List<categoryModel>> getCategory() async{
    var dbClient = await db;
    List<Map<String, dynamic>> queryResual = await dbClient!.query('category');
    return queryResual.map((e) => categoryModel.fromMap(e)).toList();
  }

  Future<List<manageModel>> getManage() async{
    var dbClient = await db;
    List<Map<String, dynamic>> queryResual = await dbClient!.query('manage');
    return queryResual.toList().map((e) => manageModel.fromMap(e)).toList();
  }

  Future<budgetModel> insertBudget(budgetModel budget) async{
    var dbClient = await db;
    await dbClient!.insert('budget', budget.toMap());
    return budget;
  }

  Future<categoryModel> insertCategory(categoryModel category) async{
    var dbClient = await db;
    await dbClient!.insert('category', category.toMap());
    return category;
  }

  Future<manageModel> insertManage(manageModel manage) async{
    var dbClient = await db;
    await dbClient!.insert('manage', manage.toMap());
    return manage;
  }

  Future<int> updateManage(manageModel manage) async{
    var dbClient = await db;
    return await dbClient!.update('manage', manage.toMap(), where: 'id=?', whereArgs: [manage.id] );
  }
  
  Future<int> deleteCategory(int idCategory) async{
    var dbClient = await db;
    return await dbClient!.delete('category', where: 'idCategory=?', whereArgs: [idCategory]);
  }

  Future<int> deleteManage(int id) async{
    var dbClient = await db;
    return await dbClient!.delete('manage', where: 'id=?', whereArgs: [id]);
  }

  Future<List> getTypePrice() async{
    var dbClient = await db;
    List<Map<String, dynamic>> queryResual = await dbClient!.rawQuery('SELECT type, price FROM manage');
    return queryResual.map((e) => manageModel.fromMap(e)).toList();
  }

  Future sumBudget() async{
    var dbClient = await db;
     return await dbClient!.rawQuery('SELECT SUM(price) FROM budget WHERE strftime("%m",dateTime) = strftime("%m","now") AND strftime("%Y",dateTime) = strftime("%Y","now")');
  }

  Future sumIncome() async{
    var dbClient = await db;
    return await dbClient!.rawQuery('SELECT SUM(price) FROM manage WHERE type = "Thu" AND strftime("%m",dateTime) = strftime("%m","now") AND strftime("%Y",dateTime) = strftime("%Y","now")');
  }

  Future sumSpend() async{
    var dbClient = await db ;
    return await dbClient!.rawQuery('SELECT SUM(price) FROM manage WHERE type = "Chi" AND strftime("%m",dateTime) = strftime("%m","now") AND strftime("%Y",dateTime) = strftime("%Y","now")');
  }

  Future<List<manageCategory>> getManageCategory() async{
    var dbClient = await db;
    List<Map<String, dynamic>> queryResual = await dbClient!.rawQuery('SELECT * from manage, category where manage.idCategory = category.idCategory ORDER BY dateTime DESC');
    return queryResual.map((e) => manageCategory.fromMap(e)).toList();
  }
  
  Future getSumInCome() async{
    var dbClient = await db;
    // List<Map<String, dynamic>> queryResual = await dbClient!.rawQuery('SELECT name, SUM(price) as price FROM manage, category WHERE manage.idCategory = category.idCategory AND type = "Thu" GROUP BY name');
    // return queryResual.map((e) => sumName.fromMap(e)).toList();
    return await dbClient!.rawQuery('SELECT name, SUM(price) FROM manage, category WHERE manage.idCategory = category.idCategory AND type = "Thu" GROUP BY name');
  }

  Future getSumSpend() async{
    var dbClient = await db;
    return await dbClient!.rawQuery('SELECT name, SUM(price) FROM manage, category WHERE manage.idCategory = category.idCategory AND type = "Chi" GROUP BY name');
  }

}


