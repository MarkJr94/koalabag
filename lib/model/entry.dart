import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

const tableEntry = "entry";
const columnId = "id";
const columnKey = "key";
const columnTitle = "title";
const columnCreatedAt = "createdAt";
const columnUrl = "url";

class Entry {
  int id;
  String key;
  String title;
  String url;
  DateTime createdAt;

  Entry(
      {@required this.key,
      @required this.title,
      @required this.url,
      this.createdAt,
      this.id});

  factory Entry.fromMap(Map<String, dynamic> map) {
    return Entry(
        id: map['id'],
        key: map['key'],
        title: map['title'],
        url: map['url'],
        createdAt: map['createdAt']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'key': key,
      'title': title,
      'url': url,
      'createdAt': createdAt.millisecondsSinceEpoch
    };
  }
}

class EntryProvider {
  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $tableEntry ( 
  $columnId integer primary key autoincrement,
  $columnKey text not null, 
  $columnTitle text not null,
  $columnUrl text not null,
  $columnCreatedAt integer not null)
''');
    });
  }

  Future<Entry> insert(Entry entry) async {
    entry.id = await db.insert(tableEntry, entry.toMap());
    return entry;
  }

  Future<Entry> getEntry(int id) async {
    List<Map> maps = await db.query(tableEntry,
        columns: [columnId, columnCreatedAt, columnTitle],
        where: "$columnId = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return new Entry.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(tableEntry, where: "$columnId = ?", whereArgs: [id]);
  }

  Future<int> update(Entry todo) async {
    return await db.update(tableEntry, todo.toMap(),
        where: "$columnId = ?", whereArgs: [todo.id]);
  }

  Future close() async => db.close();
}
