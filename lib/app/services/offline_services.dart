import 'package:flutter_trello/app/utils/todo.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

List<Map> thingstodoList = [];
List<Map> inprocessList = [];
List<Map> doneList = [];

class SqDatabase {
  String dbname = "offlineTrello.db";
  static String thingstodo = "thingstodo";
  static String inprocess = "doing";
  static String done = "done";

  Database _database;
  Todo todo = Todo();

  Future createDb() async {
    if (_database == null) {
      print("$thingstodo is empty");

      var curDir = await getDatabasesPath();
      String path = join(curDir, dbname);
      print("new database path:  $path");

      // * table created
      _database = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) => _createTable(db));

      print("Database created");
    } else {
      print("already created");
    }
  }

  static void _createTable(Database db) {
    db.execute('''
        CREATE TABLE $thingstodo (task TEXT PRIMARY KEY, date INTEGER)
      ''').then((value) => print("$thingstodo is created"));
    db.execute('''
        CREATE TABLE $inprocess (task TEXT PRIMARY KEY, date INTEGER)
      ''').then((value) => print("$inprocess is created"));
    db.execute('''
        CREATE TABLE $done (task TEXT PRIMARY KEY, date INTEGER)
      ''').then((value) => print("$done is created"));
  }

  Future<List> fetch({String tabelName}) async {
    await createDb();
    List<Map<String, dynamic>> mappedData =
        await _database.rawQuery("SELECT * FROM $tabelName ORDER BY date");

    thingstodoList.clear();
    mappedData.forEach((element) {
      print(element['task']);

      thingstodoList.add(element);
    });
    return thingstodoList;
  }

  Future shiftData({String task, int dateTime, String tableName}) async {
    await createDb();
    // return await _database.insert(inprocess, {
    //   "task": task,
    //   "date": DateTime.now().millisecondsSinceEpoch
    // });

    return await _database.rawInsert(
        "INSERT INTO $tableName (task, date) VALUES ('$task', '$dateTime')");
  }

  Future deleteRecord(String task, String tableName) async{
    await createDb();
    return await _database.rawDelete("DELETE FROM $tableName WHERE task = ?", [task]);
  }

  // ! optional datetime of millisecond is initialized
  Future<int> initData({String task, int datetime, String tableName}) async {
    await createDb();
    return await _database.insert(tableName, {
      "task": task,
      "date": datetime
    });
    // return await _database.rawInsert(
    //     "INSERT INTO $thingstodo (task, date) VALUES ('dkon', ${DateTime.now().millisecondsSinceEpoch})");
  }
}
