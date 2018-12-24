import 'dart:convert';

import 'package:built_collection/built_collection.dart';

import 'package:koalabag/consts.dart';
import 'package:koalabag/model.dart';
import 'package:koalabag/data/api.dart';

class EntryApi implements IEntryApi {
  final WallaClient _client;

  EntryApi(WallaClient client) : _client = client;

  @override
  Future<Entry> add(Uri articleUri) async {
    final uri = Uri.parse(_client.baseUrl + Consts.apiPath + '/entries.json');

    final params = {'url': articleUri.toString()};
    print('addEntry uri =  $uri');
    print('addEntry params =  $params');

    final resp = await _client.post(uri, body: params);

    if (resp.statusCode != 200) {
      throw Exception(
          "Network Error: ${resp.statusCode}: ${resp.reasonPhrase}");
    }

    return Entry.fromJson(jsonDecode(resp.body));
  }

  @override
  Stream<BuiltList<Entry>> all({int since = 0}) async* {
    final base = Uri.parse(_client.baseUrl + Consts.apiPath + '/entries.json');
    final first =
        base.replace(queryParameters: {'perPage': '100', 'since': '$since'});

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

  @override
  Future<Entry> changeEntry(Entry entry, {bool starred, bool archived}) async {
    final uri = Uri.parse(
        '${_client.baseUrl}${Consts.apiPath}/entries/${entry.id}.json');

    final params = {
      'starred': _b2i(starred ?? entry.starred()).toString(),
      'archive': _b2i(archived ?? entry.archived()).toString(),
    };

    print('changeEntry uri =  $uri');
    print('changeEntry params =  $params');

    final resp = await _client.patch(uri, body: params);

    if (resp.statusCode != 200) {
      throw Exception(
          "Network Error: ${resp.statusCode}: ${resp.reasonPhrase}");
    }

    final js = jsonDecode(resp.body);

    return Entry.fromJson(js);
  }

  @override
  Future<Entry> get(int id) async {
    final uri =
        Uri.parse('${_client.baseUrl}${Consts.apiPath}/entries/$id.json');

    print('get uri =  $uri');

    final resp = await _client.get(uri);

    if (resp.statusCode != 200) {
      throw Exception(
          "Network Error: ${resp.statusCode}: ${resp.reasonPhrase}");
    }

    return Entry.fromJson(jsonDecode(resp.body));
  }
}

int _b2i(bool it) => it ? 1 : 0;
