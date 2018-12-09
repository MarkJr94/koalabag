import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:redux/redux.dart';

import 'package:koalabag/consts.dart';
import 'package:koalabag/model.dart';
import 'package:koalabag/redux/actions.dart' as act;
import 'package:koalabag/redux/app/state.dart';
import 'package:koalabag/serializers.dart';
import 'database.dart';

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

class RealAuthDao implements AuthDao {
  @override
  Future<Auth> loadLocal() async {
    final prefs = await SharedPreferences.getInstance();
    var jsStr = prefs.getString(Prefs.auth);
    final json = jsonDecode(jsStr);
    final auth = serializers.deserializeWith(Auth.serializer, json);
    return auth;
  }

  @override
  Future<Auth> login(Uri uri, {String clientId, String clientSecret}) async {
    final resp = await http.get(uri);

    if (resp.statusCode == 200 || resp.statusCode == 302) {
      Map<String, dynamic> js = json.decode(resp.body);

      js['client_id'] = clientId;
      js['client_secret'] = clientSecret;
      js['origin'] = uri.scheme + '://' + uri.host;

      print('js = $js');

      final auth = serializers.deserializeWith(Auth.serializer, js);

      print('auth = $auth');

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(Prefs.auth, jsonEncode(js));
      return auth;
    } else {
      throw Exception("Network Error: ${resp.statusCode}");
    }
  }

  @override
  Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(Prefs.auth);
  }

  @override
  Future<Auth> refresh(Auth firstAuth) async {
    final params = {
      'grant_type': 'refresh_token',
      'client_id': firstAuth.clientId,
      'client_secret': firstAuth.clientSecret,
      'refresh_token': firstAuth.refreshToken,
    };

    final parsed = Uri.parse(firstAuth.origin);
    final uri =
        Uri(scheme: parsed.scheme, host: parsed.host, path: Consts.oauthPath);

    final resp = await http.post(uri, body: params);

    print("refresh  resp { status: ${resp.statusCode}, body: ${resp.body}");

    if (resp.statusCode == 200 || resp.statusCode == 302) {
      Map<String, dynamic> js = json.decode(resp.body);

      js['client_id'] = firstAuth.clientId;
      js['client_secret'] = firstAuth.clientSecret;
      js['origin'] = uri.scheme + '://' + uri.host;

      final auth = serializers.deserializeWith(Auth.serializer, js);

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(Prefs.auth, jsonEncode(js));

      return auth;
    } else {
      throw Exception("Network Error: ${resp.statusCode}");
    }
  }
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

class ED implements EntryDao {
  final WallaClient _client;
  final EntryProvider _provider;

  ED({@required WallaClient client, @required EntryProvider provider})
      : _client = client,
        _provider = provider;

  @override
  Future<Entry> add(Auth auth, Uri articleUri) async {
    final parsed = Uri.parse(auth.origin);
    final uri = Uri(
        scheme: parsed.scheme,
        host: parsed.host,
        path: Consts.apiPath + '/entries.json');

    final params = {
      'url': articleUri.toString(),
    };

    print('addEntry uri =  $uri');
    print('addEntry params =  $params');

    final resp = await _client.post(uri, body: params);

//    var uri = first;
    if (resp.statusCode != 200) {
      throw Exception(
          "Network Error: ${resp.statusCode}: ${resp.reasonPhrase}");
    }

    print('addEntry resp.body =  ${resp.body}');

    final js = jsonDecode(resp.body);

    return Entry.fromJson(js);
  }

  @override
  Future<Entry> loadEntryById(int id) {
    return _provider.getEntry(id);
  }

  @override
  Stream<BuiltList<Entry>> fetchEntries(Auth auth) async* {
    final parsed = Uri.parse(auth.origin);
    final first = Uri(
        scheme: parsed.scheme,
        host: parsed.host,
        path: Consts.apiPath + '/entries.json');

    var uri = first;

    // Pagination
    do {
      final resp = await _client.get(uri);
      if (resp.statusCode != 200) {
        throw Exception(
            "Network Error: ${resp.statusCode}: ${resp.reasonPhrase}");
      }
      final js = jsonDecode(resp.body);

      final jsonEntries = js['_embedded']['items'];
      assert(jsonEntries is List);

      yield BuiltList.of((jsonEntries as List).map((jEnt) {
        return Entry.fromJson(jEnt);
      }));

      final nextObj = js['_links']['next'];
      uri = null;

      if (null != nextObj) {
        final nextUri = Uri.parse(nextObj['href']);

        if (null != nextUri) {
          uri = Uri(
              scheme: first.scheme,
              host: first.host,
              path: nextUri.path,
              queryParameters: nextUri.queryParameters);
        }
      }
    } while (null != uri);
  }

  Future<bool> mergeSaveEntries(BuiltList<Entry> entries) async {
    final rows = await _provider.saveAll(entries);
    return rows != 0;
  }

  Future<Entry> updateEntry(Entry entry) async {
    final updated = await _provider.insert(entry);
    return updated;
  }

  @override
  Future<BuiltList<Entry>> loadEntries() {
    return _provider.loadAll();
  }

  @override
  Future<Entry> changeEntry(Auth auth, Entry entry,
      {bool starred, bool archived}) async {
    final parsed = Uri.parse(auth.origin);
    final uri = Uri(
        scheme: parsed.scheme,
        host: parsed.host,
        path: Consts.apiPath + '/entries/${entry.id}.json');

    final params = {
      'starred': _b2i(starred ?? entry.starred()).toString(),
      'archive': _b2i(archived ?? entry.archived()).toString(),
    };

    print('changeEntry uri =  $uri');
    print('changeEntry params =  $params');

    final resp = await _client.patch(uri, body: params);

//    var uri = first;
    if (resp.statusCode != 200) {
      throw Exception(
          "Network Error: ${resp.statusCode}: ${resp.reasonPhrase}");
    }

    print('changeEntry resp.body =  ${resp.body}');

    final js = jsonDecode(resp.body);

    return Entry.fromJson(js);
  }
}

int _b2i(bool it) => it ? 1 : 0;
