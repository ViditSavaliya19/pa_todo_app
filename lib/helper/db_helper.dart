import 'dart:io';
import 'package:pa_todo_app/model/note_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static final helper = DbHelper._();

  DbHelper._();
  String _tableName ="notes";
  String _id ="id";
  String _note ="notes";
  String _title="title";
  String _time="time";
  String _date="date";

  Database? database;

  Future<Database?> checkDb() async {
    if (database != null) {
      return database;
    } else {
      return await initDB();
    }
  }

  Future<Database> initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, "todo.db");

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        String query =
            "CREATE TABLE $_tableName ($_id INTEGER PRIMARY KEY AUTOINCREMENT,$_title TEXT,$_note TEXT,$_date TEXT, $_time TEXT)";
        db.execute(query);
      },
    );
  }

  Future<void> insertData(NotesModel model) async {
    database = await checkDb();
    database!.insert(_tableName, {_title:model.title,_note:model.notes,_date:model.date,_time:model.time});
  }

  Future<void> updateData(NotesModel model) async {
    database = await checkDb();
    database!.update(_tableName, {_title:model.title,_note:model.notes,_date:model.date,_time:model.time},where: _id,whereArgs: [model.id]);
  }

  Future<List<Map>> readData() async {
    database = await checkDb();
    String query="SELECT * FROM $_tableName";
     return await database!.rawQuery(query);
  }

  Future<void> deleteData(NotesModel model) async {
    database = await checkDb();
    database!.delete(_tableName,where: _id,whereArgs: [model.id]);
  }
}
