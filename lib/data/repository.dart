library repository;

export 'package:koalabag/data/repository/auth.dart';
export 'package:koalabag/data/repository/entry.dart';
export 'package:koalabag/data/repository/tag.dart';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';

import 'package:koalabag/model.dart';

class Global {
  static final Global _singleton = new Global._internal();
  Dao _dao;

  factory Global() {
    return _singleton;
  }

  Global._internal() {
//    ... // initialization logic here
  }

  void init(Dao dao) {
    _dao = dao;
  }

  Dao get dao {
    return _dao;
  }

//  ... // rest of the class
}

class Dao {
  IAuthDao authDao;
  IEntryDao entryDao;
  ITagDao tagDao;

  Dao({this.authDao, this.entryDao, this.tagDao});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Dao &&
          runtimeType == other.runtimeType &&
          identical(authDao, other.authDao) &&
          identical(entryDao, other.entryDao) &&
          identical(tagDao, other.tagDao);

  @override
  int get hashCode => authDao.hashCode ^ entryDao.hashCode ^ tagDao.hashCode;
}

abstract class IAuthDao {
  Future<Auth> login(Uri uri,
      {@required String clientId, @required String clientSecret});

  Future<Auth> refresh(final Auth auth);

  Future<Auth> loadLocal();

  Future<bool> logout();
}

abstract class IEntryDao {
  Future<BuiltList<EntryInfo>> getAll();

  Future<EntryInfo> getOne(final int id);

  Future<EntryInfo> add(Uri uri);

  Future<EntryInfo> changeEntry(EntryInfo ei, {bool starred, bool archived});

  Future<Entry> hydrate(EntryInfo ei);

  Future<Entry> getHydrated(int id);

  Future<void> sync();
}

abstract class ITagDao {
  Future<BuiltList<Tag>> getAll();

  Future<Tag> byId(final int id);

  Future<Tag> byLabel(final String label);

  Future<void> add(int entryId, final String label);

  Future<BuiltList<Tag>> addMany(int entryId, final Iterable<String> labels);

  Future<void> remove(int entryId, final Tag tag);

  Future<BuiltList<Tag>> getEntryTags(int entryId);

  Future<void> delete(final Tag tag);

  Future<void> deleteMany(final Iterable<Tag> tags);
}
