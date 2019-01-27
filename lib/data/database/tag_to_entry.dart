import 'package:built_collection/built_collection.dart';
import 'package:sqflite/sqflite.dart';

import 'package:koalabag/model/tag_to_entry.dart';

const tableTagMapping = 'tags_to_entries';
const columnTagId = 'tag_id';
const columnEntryId = 'entry_id';

class TagToEntryProvider {
  Database db;

  TagToEntryProvider(this.db);

  Future<void> insert(TagToEntry tag) async {
    var map = tag.toMap();

    await db.insert(tableTagMapping, map,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> insertMany(Iterable<TagToEntry> tags) async {
    return await db.transaction((tx) {
      final db = tx.batch();

      for (final tag in tags) {
        var map = tag.toMap();

        db.insert(tableTagMapping, map,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }

      db.commit(noResult: true);
    });
  }

  Future<BuiltList<TagToEntry>> getByEntryId(int entryId) async {
    List<Map<String, dynamic>> maps = await db.query(tableTagMapping,
        columns: null, where: "$columnEntryId = ?", whereArgs: [entryId]);
    return BuiltList.of(maps.map(TagToEntry.fromMap));
  }

  Future<BuiltList<TagToEntry>> getByTagId(int tagId) async {
    List<Map<String, dynamic>> maps = await db.query(tableTagMapping,
        columns: null, where: "$columnEntryId = ?", whereArgs: [tagId]);
    return BuiltList.of(maps.map(TagToEntry.fromMap));
  }

  Future<BuiltList<TagToEntry>> loadAll() async {
    final maps = await db.query(tableTagMapping, columns: null);

    return BuiltList.of(maps.map(TagToEntry.fromMap));
  }

  Future<int> delete(int entryId, int tagId) async {
    return await db.delete(tableTagMapping,
        where: "$columnEntryId = ? AND $columnTagId = ?",
        whereArgs: [entryId, tagId]);
  }

  Future close() async => db.close();
}
