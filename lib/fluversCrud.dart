
import 'package:sqflite/sqflite.dart';
import "package:path/path.dart";

import 'flavor.dart';



class fluversCrud {
  Future<List<Flavor>> getAll() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'data.db');
    // open the database
    Database database = await openDatabase(path, version: 1);

    List<Map> listMap =
    await database.rawQuery('SELECT id, name, isFavorite FROM [flavor] ');

    List<Flavor> list = [];

    for (int i = 0; i < listMap.length; i++) {
      int id = int.parse(listMap[i]['Id'].toString());
      String name = listMap[i]['name'].toString();
      bool isFavorite = listMap[i]['isFavorite'] == 0 ? false : true;
Flavor flavor = Flavor(name: name, id: id, isFavorite: isFavorite);
           // ItemTask item = ItemTask.create(id, name, isFavorite);
      list.add(flavor);
    }

    await database.close();
    return list;
  }

  Future<int> add(String name) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'data.db');
    Database database = await openDatabase(path, version: 1);
    int? id = 0;

    await database.transaction((txn) async {
      id = await txn.rawInsert(
          'INSERT INTO [flavor] (name, isFavorite) values (?,?);',
          [name, false]);
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
      id = await txn.rawDelete('DELETE FROM [flavor] WHERE id = ?;', [id]);
    });
  }

  edit(int id, String name, bool isFavorite ) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'data.db');

    Database database = await openDatabase(path, version: 1);

    int count = await database
        .rawUpdate('UPDATE [flavor] SET isFavorite = ? WHERE id = ?', [isFavorite, id]);
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
        await db.execute('CREATE TABLE [flavor](' +
            '[Id] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE DEFAULT 1,' +
            '[name] NVARCHAR(250),' +
            '[isFavorite] BOOL NOT NULL DEFAULT False);');
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
