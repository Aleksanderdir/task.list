import 'package:task_list/ItemTask.dart';
import 'package:sqflite/sqflite.dart';
import "package:path/path.dart";

class ItemTaskCrud {
  Future<List<ItemTask>> getAll() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'data.db');
    // open the database
    Database database = await openDatabase(path, version: 1);

    List<Map> listMap =
        await database.rawQuery('SELECT id, TextTask, IsExec FROM [tasks] ');

    List<ItemTask> list = [];

    for (int i = 0; i < listMap.length; i++) {
      int id = int.parse(listMap[i]['Id'].toString());
      String TextTask = listMap[i]['TextTask'].toString();
      bool IsExec = listMap[i]['IsExec'] == 0 ? false : true;

      ItemTask item = ItemTask.create(id, TextTask, IsExec);
      list.add(item);
    }

    await database.close();
    return list;
  }

  Future<int> add(String TextTask) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'data.db');
    Database database = await openDatabase(path, version: 1);
    int? id = 0;

    await database.transaction((txn) async {
      id = await txn.rawInsert(
          'INSERT INTO [tasks] (TextTask, IsExec) values (?,?);',
          [TextTask, false]);
    });

    return id!;
/*
    if (id != null) {
      return id.toInt();
    } else {
      return 0;
    }
*/
    //   print('inserted1: $id1');
  }

  del(int id) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'data.db');
    Database database = await openDatabase(path, version: 1);

    await database.transaction((txn) async {
      id = await txn.rawDelete('DELETE FROM [tasks] WHERE id = ?;', [id]);
    });
  }

  edit(int id, String TextTask, bool IsExec) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'data.db');

    Database database = await openDatabase(path, version: 1);

    int count = await database
        .rawUpdate('UPDATE [tasks] SET IsExec = ? WHERE id = ?', [IsExec, id]);
    print('updated: $count');

    await database.close();
  }

  Future init() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'data.db');
    // open the database
    Database database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        // When creating the db, create the table
        await db.execute('CREATE TABLE [tasks](' +
            '[Id] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE DEFAULT 1,' +
            '[TextTask] NVARCHAR(250),' +
            '[IsExec] BOOL NOT NULL DEFAULT False);');
      },
    );

// Insert some records in a transaction
    // await database.transaction((txn) async {
    //   await txn.rawDelete('delete from [tasks]');

    //   int id1 = await txn.rawInsert(
    //         'INSERT INTO tasks(TextTask, IsExec) values ("Task -1", false);');
    //   print('inserted1: $id1');
    //  int id2 = await txn.rawInsert(
    //     'INSERT INTO tasks(TextTask, IsExec) values ("Task -2", true);');
    //    print('inserted2: $id2');
    // });

    // await database.close();
  }
}
