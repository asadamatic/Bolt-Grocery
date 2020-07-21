import 'package:boltgrocery/DataModels/Category.dart';
import 'package:boltgrocery/DataModels/GroceryItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase extends ChangeNotifier{

  LocalDatabase();

  static const  databaseName = 'new.db';
  static Database _database;


  Future<Database> get database async{

    if (_database == null){

      return await initializeDB();
    }else{

      return _database;
    }
  }

  initializeDB() async{
    return await openDatabase(
        join(await getDatabasesPath(), databaseName),
        version: 1,
        onCreate: (db, version) async{

          return await db.execute('CREATE TABLE grocerytable(id INTEGER PRIMARY KEY AUTOINCREMENT, time TEXT, name TEXT, quantity TEXT, unit TEXT, category TEXT, status INTEGER)');
        }
    );
  }

  bool getStatus(int status){

    return status == 1 ? true : false;
  }

  GroceryItem returnGroceryItem(Map<String, dynamic> map){

    return GroceryItem(
      id: map['id'],
      time: DateTime.parse(map['time']),
      name: map['name'],
      quantity: map['quantity'],
      unit: map['unit'],
      category: map['category'],
      status: getStatus(map['status']),
    );
  }
  Future<List<GroceryItem>> returnGroceryItems(String categorySlug) async{

    final Database db = await database;
    final List<Map<String, dynamic>> list = await db.query('grocerytable', where: 'category = "$categorySlug"');
    return list.map(returnGroceryItem).toList();
  }

  Future<void> insertData(GroceryItem groceryItem) async{

    final Database db = await database;
    db.insert('grocerytable', groceryItem.toMap());
    notifyListeners();
  }

  Future<void> update(GroceryItem groceryItem) async{

    final Database db = await database;
    db.update('grocerytable', groceryItem.toMap(), where: 'id = ?', whereArgs: [groceryItem.id]);
    notifyListeners();
  }

  Future<void> delete(GroceryItem groceryItem) async{

    final Database db = await database;
    db.delete('grocerytable', where: 'id = ?', whereArgs: [groceryItem.id]);
    notifyListeners();
  }
}