import 'package:built_collection/built_collection.dart';
import 'package:sqflite/sqflite.dart';

import 'package:koalabag/model/tag.dart';

const tableTag = "tags";
const _columnId = "id";

const tableTagMapping = 'tags_to_entries';
const columnTagId = 'tag_id';
const columnEntryId = 'entry_id';

class TagProvider {
  Database db;

  TagProvider(this.db);

  Future<Tag> insert(Tag ei) async {
    var map = ei.toMap();
    map.remove('tags');

    await db.insert(tableTag, map,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return ei;
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
    final inList = ids.join(', ');
    final inParams = ids.map((_) => '?').join(',');

    List<Map<String, dynamic>> maps = await db.query(tableTag,
        columns: null, where: "$_columnId IN ($inParams)", whereArgs: [inList]);
    return BuiltList.of(maps.map(Tag.fromMap));
  }

  Future<int> delete(int id) async {
    return await db.delete(tableTag, where: "$_columnId = ?", whereArgs: [id]);
  }

  Future<int> update(Tag ei) async {
    var map = ei.toMap();
    map.remove('tags');

    return await db
        .update(tableTag, map, where: "$_columnId = ?", whereArgs: [ei.id]);
  }

  Future<int> saveAll(Iterable<Tag> eis) async {
    return await db.transaction((tx) {
      final db = tx.batch();

      for (final ei in eis) {
        var map = ei.toMap();
        map.remove('tags');

        db.insert(tableTag, map, conflictAlgorithm: ConflictAlgorithm.replace);
      }

      db.commit(noResult: true);
    });
  }

  Future<BuiltList<Tag>> loadAll() async {
    final maps =
        await db.query(tableTag, columns: null, orderBy: 'created_at DESC');

    return BuiltList.of(maps.map(Tag.fromMap));
  }

  Future<int> deleteMany(Iterable<int> ids) async {
    final inList = ids.join(', ');
    final inParams = ids.map((_) => '?').join(',');

    return await db.delete(tableTag,
        where: "$_columnId IN ($inParams)", whereArgs: [inList]);
  }

  Future<BuiltList<int>> allIds() async {
    final rows = await db.query(tableTag,
        columns: [_columnId], orderBy: 'created_at DESC');
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
    return await db.delete(tableTag,
        where: "$columnTagId = ? AND $columnEntryId = ?",
        whereArgs: [tagId, entryId]);
  }

  Future close() async => db.close();
}
