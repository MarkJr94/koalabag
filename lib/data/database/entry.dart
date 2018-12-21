import 'package:built_collection/built_collection.dart';
import 'package:sqflite/sqflite.dart';

import 'package:koalabag/model.dart';

const tableEntry = "entry";
const columnId = "id";
const columnUrl = "url";
const columnCreatedAt = "created_at";

class EntryProvider {
  Database db;

  Future open(String path) async {
//    final dbPath = ":memory:";
    final dbPath = "koalabag.db";

    db = await openDatabase(dbPath, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $tableEntry (
  id integer primary key,
  content text ,
  created_at text ,
  domain_name text ,
  is_archived integer not null,
  is_starred integer not null,
  language text,
  mimetype text,
  preview_picture text,
  reading_time integer not null,
  title text not null,
  updated_at text,
  url text not null,
  user_email text,
  user_id integer not null,
  user_name text)
''');
    });
  }

  Future<Entry> insert(Entry entry) async {
    var map = entry.toJson();
    map.remove('tags');

    await db.insert(tableEntry, map,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return entry;
  }

  Future<Entry> getEntry(int id) async {
    List<Map> maps = await db.query(tableEntry,
        columns: null, where: "$columnId = ?", whereArgs: [id]);
    if (maps.length > 0) {
      return Entry.fromJson(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(tableEntry, where: "$columnId = ?", whereArgs: [id]);
  }

  Future<int> update(Entry entry) async {
    var map = entry.toJson();
    map.remove('tags');

    return await db
        .update(tableEntry, map, where: "$columnId = ?", whereArgs: [entry.id]);
  }

  Future<int> saveAll(BuiltList<Entry> entries) async {
    return await db.transaction((tx) {
      final db = tx.batch();

      for (final entry in entries) {
        var map = entry.toMap();
        map.remove('tags');

        db.insert(tableEntry, map,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }

      db.commit(noResult: true);
    });
  }

  Future<BuiltList<Entry>> loadAll() async {
    final maps =
        await db.query(tableEntry, columns: null, orderBy: 'created_at DESC');

    return BuiltList.of(maps.map((map) => Entry.fromJson(map)));
  }

  Future<int> deleteMany(BuiltList<int> ids) async {
    final inList = ids.join(', ');
    final inParams = ids.map((_) => '?').join(',');

    return await db.delete(tableEntry,
        where: "$columnId IN ($inParams)", whereArgs: [inList]);
  }

  Future<BuiltList<int>> allIds() async {
    final rows = await db.query(tableEntry,
        columns: [columnId], orderBy: 'created_at DESC');
    return BuiltList.of(rows.map((row) => row[columnId]));
  }

  Future<DateTime> getLatest() async {
    final rows = await db.query(tableEntry,
        columns: null, orderBy: 'created_at DESC', limit: 1);

    if (rows.isNotEmpty) {
      final entry = Entry.fromMap(rows[0]);
      return entry.createdAt;
    }

    return DateTime.fromMicrosecondsSinceEpoch(0, isUtc: true);
  }

  Future close() async => db.close();
}
