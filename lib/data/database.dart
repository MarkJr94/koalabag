library database;

export 'package:koalabag/data/database/entry_content.dart';
export 'package:koalabag/data/database/entry_info.dart';

import 'package:sqflite/sqflite.dart';

import 'package:koalabag/data/database/entry_info.dart';
import 'package:koalabag/data/database/entry_content.dart';

class Provider {
  Database db;
  EntryInfoProvider _infoProvider;
  EntryContentProvider _contentProvider;

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
}
