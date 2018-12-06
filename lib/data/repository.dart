import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:redux/redux.dart';

import 'package:koalabag/consts.dart';
import 'package:koalabag/model/auth.dart';
import 'package:koalabag/model/entry.dart';
import 'package:koalabag/redux/actions.dart' as act;
import 'package:koalabag/redux/state.dart';
import 'package:koalabag/serializers.dart';

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
    final tok = _store.state.auth?.access_token;
    print('tok = $tok');

    request.headers['Authorization'] = 'Bearer $tok';
//    request.url.queryParameters.putIfAbsent('access_token', () => tok);
//    request.

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
      'client_id': firstAuth.client_id,
      'client_secret': firstAuth.client_secret,
      'refresh_token': firstAuth.refresh_token,
    };

    final parsed = Uri.parse(firstAuth.origin);
    final uri =
        Uri(scheme: parsed.scheme, host: parsed.host, path: Consts.oauthPath);

    final resp = await http.post(uri, body: params);

    print("refresh  resp { status: ${resp.statusCode}, body: ${resp.body}");

    if (resp.statusCode == 200 || resp.statusCode == 302) {
      Map<String, dynamic> js = json.decode(resp.body);

      js['client_id'] = firstAuth.client_id;
      js['client_secret'] = firstAuth.client_secret;
      js['origin'] = uri.scheme + '://' + uri.host;

      final auth = serializers.deserializeWith(Auth.serializer, js);

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(Prefs.auth, jsonEncode(js));

      return auth.rebuild((b) => b..refresh_token = firstAuth.refresh_token);
    } else {
      throw Exception("Network Error: ${resp.statusCode}");
    }
  }
}

abstract class EntryDao {
  Future<List<Entry>> loadEntries();

  Future<bool> mergeSaveEntries(List<Entry> entries);

  Stream<List<Entry>> fetchEntries(Auth auth);

  Future<Entry> loadEntryById(final String id);

  Future<String> add(Entry entry);
}

class ED implements EntryDao {
  final WallaClient _client;
  final EntryProvider _provider;

  ED({@required WallaClient client, @required EntryProvider provider})
      : _client = client,
        _provider = provider;

  @override
  Future<String> add(Entry entry) {
    // TODO: implement add
    return null;
  }

  @override
  Future<Entry> loadEntryById(String id) {
    // TODO: implement entryById
    return null;
  }

  @override
  Stream<List<Entry>> fetchEntries(Auth auth) async* {
    final parsed = Uri.parse(auth.origin);
    final first = Uri(
        scheme: parsed.scheme,
        host: parsed.host,
        path: Consts.apiPath + '/entries.json');

    var uri = first;

    do {
      final resp = await _client.get(uri);
      if (resp.statusCode != 200) {
        throw Exception(
            "Network Error: ${resp.statusCode}: ${resp.reasonPhrase}");
      }
      final js = jsonDecode(resp.body);

      final jsonEntries = js['_embedded']['items'];
      assert(jsonEntries is List);

      yield (jsonEntries as List).map((jEnt) {
//        print("jEnt = $jEnt");
        return Entry.fromJson(jEnt);
      }).toList();

      // Pagination

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

  Future<bool> mergeSaveEntries(List<Entry> entries) async {
    print('mergeSave 10 entries');
    final rows = await _provider.saveAll(entries);
    return rows != 0;
  }

  @override
  Future<List<Entry>> loadEntries() {
    return _provider.loadAll();
  }
}
