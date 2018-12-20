import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';

import 'package:koalabag/consts.dart';
import 'package:koalabag/model.dart';
import 'package:koalabag/data/repository.dart';
import 'package:koalabag/data/database.dart';

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

  Future<bool> sync() async {
    // First check if all local entries exist

    return false;
  }
}

int _b2i(bool it) => it ? 1 : 0;
