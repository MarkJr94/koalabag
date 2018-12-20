library repository;

export 'package:koalabag/data/repository/entry.dart';
export 'package:koalabag/data/repository/auth.dart';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';

import 'package:koalabag/model.dart';
import 'package:koalabag/redux/actions.dart' as act;
import 'package:koalabag/redux/app/state.dart';

// Custom Client
class WallaClient extends http.BaseClient {
  final http.Client _inner;
  Store<AppState> _store;

  WallaClient({@required http.Client client, Store<AppState> store})
      : _inner = client,
        _store = store,
        super();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    final tok = _store.state.auth?.accessToken;

    request.headers['Authorization'] = 'Bearer $tok';

    final resp = _inner.send(request);

    final ret = resp.then((resp) {
      if (resp.statusCode == 401) {
        _store.dispatch(act.AuthRefresh());
      }

      return resp;
    });
    return ret;
  }

  set store(Store<AppState> store) {
    _store = store;
  }
}

class Dao {
  AuthDao authDao;
  EntryDao entryDao;

  Dao({this.authDao, this.entryDao});
}

abstract class AuthDao {
  Future<Auth> login(Uri uri,
      {@required String clientId, @required String clientSecret});

  Future<Auth> refresh(final Auth auth);

  Future<Auth> loadLocal();

  Future<bool> logout();
}

abstract class EntryDao {
  Future<BuiltList<Entry>> loadEntries();

  Future<bool> mergeSaveEntries(BuiltList<Entry> entries);

  Stream<BuiltList<Entry>> fetchEntries(Auth auth);

  Future<Entry> loadEntryById(final int id);

  Future<Entry> add(Auth auth, Uri uri);

  Future<Entry> changeEntry(Auth auth, Entry entry,
      {bool starred, bool archived});

  Future<Entry> updateEntry(Entry entry);
}
