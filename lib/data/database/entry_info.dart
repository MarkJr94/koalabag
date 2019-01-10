import 'package:built_collection/built_collection.dart';
import 'package:sqflite/sqflite.dart';

import 'package:koalabag/model/entry_info.dart';

const tableEntryInfo = "entry_info";
const _columnId = "id";

class EntryInfoProvider {
  Database db;

  EntryInfoProvider(this.db);

  Future<EntryInfo> insert(EntryInfo ei) async {
    var map = ei.toMap();
    map.remove('tags');

    await db.insert(tableEntryInfo, map,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return ei;
  }

  Future<EntryInfo> get(int id) async {
    List<Map> maps = await db.query(tableEntryInfo,
        columns: null, where: "$_columnId = ?", whereArgs: [id]);
    if (maps.length > 0) {
      return EntryInfo.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db
        .delete(tableEntryInfo, where: "$_columnId = ?", whereArgs: [id]);
  }

  Future<int> update(EntryInfo ei) async {
    var map = ei.toMap();
    map.remove('tags');

    return await db.update(tableEntryInfo, map,
        where: "$_columnId = ?", whereArgs: [ei.id]);
  }

  Future<int> saveAll(Iterable<EntryInfo> eis) async {
    return await db.transaction((tx) {
      final db = tx.batch();

      for (final ei in eis) {
        var map = ei.toMap();
        map.remove('tags');

        db.insert(tableEntryInfo, map,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }

      db.commit(noResult: true);
    });
  }

  Future<BuiltList<EntryInfo>> loadAll() async {
    final maps = await db.query(tableEntryInfo,
        columns: null, orderBy: 'created_at DESC');

    return BuiltList.of(maps.map(EntryInfo.fromMap));
  }

  Future<int> deleteMany(Iterable<int> ids) async {
    final inParams = ids.map((_) => '?').join(',');

    return await db.delete(tableEntryInfo,
        where: "$_columnId IN ($inParams)", whereArgs: ids.toList());
  }

  Future<BuiltList<int>> allIds() async {
    final rows = await db.query(tableEntryInfo,
        columns: [_columnId], orderBy: 'created_at DESC');
    return BuiltList.of(rows.map((row) => row[_columnId]));
  }

  Future<DateTime> getLatest() async {
    final rows = await db.query(tableEntryInfo,
        columns: null, orderBy: 'created_at DESC', limit: 1);

    if (rows.isNotEmpty) {
      final entry = EntryInfo.fromMap(rows[0]);
      return entry.createdAt;
    }

    return DateTime.fromMicrosecondsSinceEpoch(0, isUtc: true);
  }

  Future close() async => db.close();
}
