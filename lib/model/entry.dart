import 'package:sqflite/sqflite.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';

import 'package:koalabag/serializers.dart';

part 'entry.g.dart';

const tableEntry = "entry";
const columnId = "id";
const columnKey = "key";
const columnTitle = "title";
const columnCreatedAt = "createdAt";
const columnUrl = "url";

abstract class Tag implements Built<Tag, TagBuilder> {
  static Serializer<Tag> get serializer => _$tagSerializer;

  int get id;
  String get label;
  String get slug;

  Tag._();

  factory Tag([updates(TagBuilder b)]) = _$Tag;
}

abstract class Entry implements Built<Entry, EntryBuilder> {
  static Serializer<Entry> get serializer => _$entrySerializer;

  @nullable
  String get content;

  DateTime get created_at;

  @nullable
  String get domain_name;

  int get id;

  int get is_archived;

  int get is_starred;

  @nullable
  String get language;

  @nullable
  String get mimetype;

  @nullable
  String get preview_picture;

  int get reading_time;

  BuiltList<Tag> get tags;

  String get title;

  DateTime get updated_at;

  String get url;

  String get user_email;

  int get user_id;

  String get user_name;

  Entry._();

  factory Entry([updates(EntryBuilder b)]) = _$Entry;

  static Entry fromJson(Map<String, dynamic> map) {
    return serializers.deserializeWith(Entry.serializer, map);
  }

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(serializer, this);
  }

  Map<String, dynamic> toMap() {
    return serializers.serializeWith(serializer, this);
  }

  static Entry fromMap(Map<String, dynamic> map) {
    return serializers.deserializeWith(Entry.serializer, map);
  }
}

class EntryProvider {
  Database db;

  Future open(String path) async {
    final dbPath = ":memory:";
//    final dbPath = Consts.dbPath;
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

  Future<int> saveAll(List<Entry> entries) async {
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

  Future<List<Entry>> loadAll() async {
    final maps = await db.query(tableEntry, columns: null);

    return maps.map((map) => Entry.fromJson(map)).toList();
//
//
//    return await db.transaction((tx) {
//      final db = tx.batch();
//
//      for (final entry in entries) {
//        var map = entry.toJson();
//        map.remove('tags');
//
//        db.insert('entries', map);
//      }
//
//      db.commit(noResult: true);
//    });
  }

  Future close() async => db.close();
}
