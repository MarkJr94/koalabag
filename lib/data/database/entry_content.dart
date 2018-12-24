import 'package:built_collection/built_collection.dart';
import 'package:sqflite/sqflite.dart';

import 'package:koalabag/model/entry_content.dart';

const tableEntryContent = "entry_content";
const _columnId = "id";

class EntryContentProvider {
  Database db;

  EntryContentProvider(this.db);

  Future<EntryContent> insert(EntryContent ec) async {
    var map = ec.toMap();

    await db.insert(tableEntryContent, map,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return ec;
  }

  Future<EntryContent> get(int id) async {
    List<Map> maps = await db.query(tableEntryContent,
        columns: null, where: "$_columnId = ?", whereArgs: [id]);
    if (maps.length > 0) {
      return EntryContent.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db
        .delete(tableEntryContent, where: "$_columnId = ?", whereArgs: [id]);
  }

  Future<int> update(EntryContent ec) async {
    var map = ec.toMap();

    return await db.update(tableEntryContent, map,
        where: "$_columnId = ?", whereArgs: [ec.id]);
  }

  Future<int> saveAll(Iterable<EntryContent> ecs) async {
    return await db.transaction((tx) {
      final db = tx.batch();

      for (final ei in ecs) {
        var map = ei.toMap();
        map.remove('tags');

        db.insert(tableEntryContent, map,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }

      db.commit(noResult: true);
    });
  }

  Future<BuiltList<EntryContent>> loadAll() async {
    final maps = await db.query(tableEntryContent,
        columns: null, orderBy: 'created_at DESC');

    return BuiltList.of(maps.map(EntryContent.fromMap));
  }

  Future<int> deleteMany(Iterable<int> ids) async {
    final inList = ids.join(', ');
    final inParams = ids.map((_) => '?').join(',');

    return await db.delete(tableEntryContent,
        where: "$_columnId IN ($inParams)", whereArgs: [inList]);
  }

  Future<BuiltList<int>> allIds() async {
    final rows = await db.query(tableEntryContent,
        columns: [_columnId], orderBy: 'created_at DESC');
    return BuiltList.of(rows.map((row) => row[_columnId]));
  }

  Future close() async => db.close();
}
