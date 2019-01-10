import 'package:built_collection/built_collection.dart';
import 'package:sqflite/sqflite.dart';

import 'package:koalabag/model/tag.dart';
import 'package:koalabag/data/database/tag_to_entry.dart';

const tableTag = "tags";
const _columnId = "id";
const _columnLabel = "label";

class TagProvider {
  Database db;

  TagProvider(this.db);

  Future<void> insert(Tag tag) async {
    var map = tag.toMap();

    await db.insert(tableTag, map,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> insertMany(Iterable<Tag> tags) async {
    return await db.transaction((tx) {
      final db = tx.batch();

      for (final tag in tags) {
        var map = tag.toMap();

        db.insert(tableTag, map, conflictAlgorithm: ConflictAlgorithm.replace);
      }

      db.commit(noResult: true);
    });
  }

  Future<Tag> get(int id) async {
    List<Map> maps = await db.query(tableTag,
        columns: null, where: "$_columnId = ?", whereArgs: [id]);
    if (maps.length > 0) {
      return Tag.fromMap(maps.first);
    }
    return null;
  }

  Future<BuiltList<Tag>> getMany(Iterable<int> ids) async {
    final inParams = ids.map((_) => '?').join(',');

    List<Map<String, dynamic>> maps = await db.query(tableTag,
        columns: null,
        where: "$_columnId IN ($inParams)",
        whereArgs: ids.toList());
    return BuiltList.of(maps.map(Tag.fromMap));
  }

  Future<Tag> getByLabel(String label) async {
    List<Map> maps = await db.query(tableTag,
        columns: null,
        where: "$_columnLabel = ?",
        whereArgs: [label],
        limit: 1);
    if (maps.length > 0) {
      return Tag.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(tableTag, where: "$_columnId = ?", whereArgs: [id]);
  }

  Future<int> deleteMany(Iterable<int> ids) async {
    final inParams = ids.map((_) => '?').join(',');

    return await db.delete(tableTag,
        where: "$_columnId IN ($inParams)", whereArgs: ids.toList());
  }

  Future<int> update(Tag tag) async {
    var map = tag.toMap();

    return await db
        .update(tableTag, map, where: "$_columnId = ?", whereArgs: [tag.id]);
  }

  Future<BuiltList<Tag>> loadAll() async {
    final maps = await db.query(tableTag, columns: null);

    return BuiltList.of(maps.map(Tag.fromMap));
  }

  Future<BuiltList<int>> allIds() async {
    final rows = await db.query(tableTag, columns: [_columnId]);
    return BuiltList.of(rows.map((row) => row[_columnId]));
  }

  Future<int> addToEntry(int entryId, int tagId) async {
    return await db
        .insert(tableTagMapping, {columnEntryId: entryId, columnTagId: tagId});
  }

  Future<BuiltList<Tag>> allFromEntry(int entryId) async {
    final rows = await db.query(tableTagMapping,
        columns: [columnTagId],
        where: '$columnEntryId = ?',
        whereArgs: [entryId]);
    final tagIds = rows.map((row) => row[columnTagId]);
    return await getMany(tagIds);
  }

  Future<int> removeFromEntry(int entryId, int tagId) async {
    return await db.delete(tableTagMapping,
        where: "$columnTagId = ? AND $columnEntryId = ?",
        whereArgs: [tagId, entryId]);
  }

  Future close() async => db.close();
}
