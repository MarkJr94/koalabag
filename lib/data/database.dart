library database;

export 'package:koalabag/data/database/entry_content.dart';
export 'package:koalabag/data/database/entry_info.dart';
export 'package:koalabag/data/database/tag.dart';

import 'package:sqflite/sqflite.dart';

import 'package:koalabag/data/database/entry_info.dart';
import 'package:koalabag/data/database/entry_content.dart';
import 'package:koalabag/data/database/tag.dart';

//const _tableTagMapping = 'tags_to_entries';
//const _columnTagId = 'tag_id';
//const _columnEntryId = 'entry_id';

class Provider {
  Database db;
  EntryInfoProvider _infoProvider;
  EntryContentProvider _contentProvider;
  TagProvider _tagProvider;

  Provider(this.db);

  static Future<Provider> open(String path, {version = 1}) async {
    final db = await openDatabase(path, version: version,
        onCreate: (db, version) async {
      await db.execute('''
create table $tableEntryInfo (
  id integer primary key,
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

      await db.execute('''
create table $tableEntryContent (
  id integer primary key,
  content text)
''');

      await db.execute('''
create table $tableTag (
  id integer primary key,
  label text,
  slug text)
''');
    });

    await db.execute('''
create table $tableTagMapping (
  $columnEntryId int,
  $columnTagId int)
''');

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
}
