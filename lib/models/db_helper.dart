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
    await db.execute('CREATE TABLE budget(id INTEGER PRIMARY KEY AUTOINCREMENT, price INTEGER, dateTime TEXT)');
    await db.execute('CREATE TABLE category(idCategory INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT,icon TEXT, color TEXT)');
    await db.execute('CREATE TABLE manage(id INTEGER PRIMARY KEY AUTOINCREMENT, idCategory INTEGER, price INTEGER, type TEXT,dateTime DATE, comment TEXT, FOREIGN KEY (idCategory) REFERENCES category(idCategory))');
    await db.transaction((txn) async {
      int idCategory1 = await txn.rawInsert(
          'INSERT INTO category(name, icon, color) VALUES("Tổng hợp","lib/assets/icons/tax.png","0xffFDE683")');
      int idCategory2 = await txn.rawInsert(
          'INSERT INTO category(name, icon, color) VALUES("Game","lib/assets/icons/game.png","0xff7EA2E9")');
      int idCategory3 = await txn.rawInsert(
          'INSERT INTO category(name, icon, color) VALUES("Làm đẹp","lib/assets/icons/lipstick.png","0xffFA6899")');
      int idCategory4 = await txn.rawInsert(
          'INSERT INTO category(name, icon, color) VALUES("Lương","lib/assets/icons/bank.png","0xff9FC663")');
      int idCategory5 = await txn.rawInsert(
          'INSERT INTO category(name, icon, color) VALUES("Vé xe bus","lib/assets/icons/bus.png","0xffABCEEE")');
      int idCategory6 = await txn.rawInsert(
          'INSERT INTO category(name, icon, color) VALUES("Sách","lib/assets/icons/book.png","0xffFE9539")');
      int idCategory7 = await txn.rawInsert(
          'INSERT INTO category(name, icon, color) VALUES("Vé máy bay","lib/assets/icons/fly.png","0xff61AEC2")');
      int idCategory8 = await txn.rawInsert(
          'INSERT INTO category(name, icon, color) VALUES("Hoa quả","lib/assets/icons/apple.png","0xffE94345")');
      int idCategory9 = await txn.rawInsert(
          'INSERT INTO category(name, icon, color) VALUES("Thể thao","lib/assets/icons/sport.png","0xffDBD369")');
    });
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
    List<Map<String, dynamic>> queryResual = await dbClient!.rawQuery('SELECT * from manage, category where manage.idCategory = category.idCategory AND strftime("%m",dateTime) = strftime("%m","now") ORDER BY dateTime DESC');
    return queryResual.map((e) => manageCategory.fromMap(e)).toList();
  }
  
  Future getSumInCome() async{
    var dbClient = await db;
    return await dbClient!.rawQuery('SELECT name, SUM(price), icon, color FROM manage, category WHERE manage.idCategory = category.idCategory AND type = "Thu" AND strftime("%m",dateTime) = strftime("%m","now") GROUP BY name');
  }

  Future getSumSpend() async{
    var dbClient = await db;
   return await dbClient!.rawQuery('SELECT name, SUM(price), icon, color FROM manage, category WHERE manage.idCategory = category.idCategory AND type = "Chi" AND strftime("%m",dateTime) = strftime("%m","now") GROUP BY name');
  }
  
  Future sumIncomeMonth() async{
    var dbClient = await db;
    return await dbClient!.rawQuery('SELECT strftime("%m", dateTime) as month, SUM(price) FROM manage WHERE type = "Thu" AND strftime("%Y", dateTime) = strftime("%Y", "now") GROUP BY month ');
  }


  Future sumSpendMonth() async{
    var dbClient = await db;
    return await dbClient!.rawQuery('SELECT strftime("%m", dateTime) as month, SUM(price) FROM manage WHERE type = "Chi" AND strftime("%Y", dateTime) = strftime("%Y", "now") GROUP BY month ORDER By month');
  }



}


