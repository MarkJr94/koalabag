library database;

export 'package:koalabag/data/database/entry_content.dart';
export 'package:koalabag/data/database/entry_info.dart';
export 'package:koalabag/data/database/tag.dart';
export 'package:koalabag/data/database/tag_to_entry.dart';

import 'package:sqflite/sqflite.dart';

import 'package:koalabag/data/database/entry_info.dart';
import 'package:koalabag/data/database/entry_content.dart';
import 'package:koalabag/data/database/tag.dart';
import 'package:koalabag/data/database/tag_to_entry.dart';

class Provider {
  Database db;
  EntryInfoProvider _infoProvider;
  EntryContentProvider _contentProvider;
  TagProvider _tagProvider;
  TagToEntryProvider _tagToEntryProvider;

  Provider(this.db);

  static Future<Provider> open(String path, {version = 1}) async {
    final db = await openDatabase(path, version: version,
        onCreate: (db, version) async {
      await db.execute('''
CREATE table $tableEntryInfo (
  id INTEGER PRIMARY KEY,
  created_at TEXT ,
  domain_name TEXT ,
  is_archived INTEGER NOT NULL,
  is_starred INTEGER NOT NULL,
  language TEXT,
  mimetype TEXT,
  preview_picture TEXT,
  reading_time INTEGER NOT NULL,
  title TEXT NOT NULL,
  updated_at TEXT,
  url TEXT NOT NULL,
  user_email TEXT,
  user_id INTEGER NOT NULL,
  user_name TEXT)
''');

      await db.execute('''
CREATE table $tableEntryContent (
  id INTEGER PRIMARY KEY,
  content TEXT)
''');

      await db.execute('''
CREATE table $tableTag (
  id INTEGER PRIMARY KEY,
  label TEXT,
  slug TEXT)
''');

      await db.execute('''
CREATE table $tableTagMapping (
  $columnEntryId int,
  $columnTagId int,
  FOREIGN KEY ($columnEntryId)
    REFERENCES $tableEntryInfo(id)
    ON DELETE CASCADE,
  FOREIGN KEY ($columnTagId)
    REFERENCES $tableTag(id)
    ON DELETE CASCADE,
  UNIQUE($columnEntryId, $columnTagId) ON CONFLICT REPLACE
)
''');
    });

    return Provider(db);
  }

  EntryInfoProvider get entryInfoProvider {
    if (null == _infoProvider) {
      _infoProvider = EntryInfoProvider(db);
    }
    return _infoProvider;
  }

  EntryContentProvider get entryContentProvider {
    if (null == _contentProvider) {
      _contentProvider = EntryContentProvider(db);
    }
    return _contentProvider;
  }

  TagProvider get tagProvider {
    if (null == _tagProvider) {
      _tagProvider = TagProvider(db);
    }

    return _tagProvider;
  }

  TagToEntryProvider get tagToEntryProvider {
    if (null == _tagToEntryProvider) {
      _tagToEntryProvider = TagToEntryProvider(db);
    }

    return _tagToEntryProvider;
  }
}
