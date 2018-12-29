library api;

export 'package:koalabag/data/api/auth.dart';
export 'package:koalabag/data/api/entry.dart';
export 'package:koalabag/data/api/tag.dart';

import 'package:built_collection/built_collection.dart';
import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';

import 'package:koalabag/redux/actions.dart' as act;
import 'package:koalabag/redux/app/state.dart';
import 'package:koalabag/model.dart';

class Api {
  final IEntryApi entryApi;
  final IAuthApi authApi;

  Api(this.entryApi, this.authApi);
}

abstract class IEntryApi {
  Future<Entry> add(Uri articleUri);
  Future<Entry> get(int id);
  Future<Entry> changeEntry(Entry entry, {bool starred, bool archived});
  Stream<BuiltList<Entry>> all({int since = 0});
}

abstract class IAuthApi {
  Future<Auth> login(Uri uri, {String clientId, String clientSecret});
  Future<Auth> refresh(Auth old);
}

abstract class ITagApi {
  Future<BuiltList<Tag>> all();
  Future<void> deleteById(int id);
  Future<void> deleteByLabel(String label);
  Future<void> deleteManyByLabel(BuiltList<String> labels);
  Future<void> addToEntry(int entryId, BuiltList<String> labels);
  Future<void> removeFromEntry(int entryId, int tagId);
  Future<BuiltList<Tag>> allFromEntry(int entryId);
}

// Custom Client
class WallaClient extends http.BaseClient {
  final http.Client _inner;
  Store<AppState> _store;

  WallaClient(http.Client client, {Store<AppState> store})
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

  String get baseUrl {
    return _store.state.auth?.origin;
  }
}
