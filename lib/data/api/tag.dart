import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:http/http.dart';

import 'package:koalabag/consts.dart';
import 'package:koalabag/model.dart';
import 'package:koalabag/data/api.dart';

class TagApi implements ITagApi {
  final WallaClient _client;

  TagApi(WallaClient client) : _client = client;

  @override
  Future<BuiltList<Tag>> all() async {
    final uri = Uri.parse(_client.baseUrl + Consts.apiPath + '/tags.json');

    final resp = await _client.get(uri);

    if (resp.statusCode != 200) {
      throw Exception(
          "Network Error: ${resp.statusCode}: ${resp.reasonPhrase}");
    }

    final js = jsonDecode(resp.body);
    assert(js is List);
    final jsonTags = js as List;

    final tags = BuiltList.of(jsonTags.map((jsonTag) => Tag.fromMap(jsonTag)));
    return tags;
  }

  @override
  Future<void> deleteById(int id) async {
    final uri = Uri.parse(_client.baseUrl + Consts.apiPath + '/tags/$id.json');
    final resp = await _client.delete(uri);
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception(
          "Network Error: ${resp.statusCode}: ${resp.reasonPhrase}");
    }
    return null;
  }

  @override
  Future<void> deleteByLabel(String label) async {
    final baseUri =
        Uri.parse(_client.baseUrl + Consts.apiPath + '/tag/label.json');

    final uri = baseUri.replace(queryParameters: {'tag': label});

    final resp = await _client.delete(uri);
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception(
          "Network Error: ${resp.statusCode}: ${resp.reasonPhrase}");
    }
    return null;
  }

  @override
  Future<void> deleteManyByLabel(Iterable<String> labels) async {
    final uri =
        Uri.parse(_client.baseUrl + Consts.apiPath + '/tags/label.json');
    final tagsStr = labels.join(',');

    var req = Request('DELETE', uri);
    req.body = jsonEncode({'tags': tagsStr});

    final streamResp = await _client.send(req);

    if (streamResp.statusCode < 200 || streamResp.statusCode >= 300) {
      throw Exception(
          "Network Error: ${streamResp.statusCode}: ${streamResp.reasonPhrase}");
    }

    return null;
  }

  @override
  Future<BuiltList<Tag>> addToEntry(
      int entryId, Iterable<String> labels) async {
    final url = Uri.parse(
        _client.baseUrl + Consts.apiPath + '/entries/$entryId/tags.json');
    final resp =
        await _client.post(url, body: jsonEncode({'tags': labels.join(',')}));

    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception(
          "Network Error: ${resp.statusCode}: ${resp.reasonPhrase}");
    }

    final js = jsonDecode(resp.body);
    assert(js is List);
    final jsonTags = js as List;

    final tags = BuiltList.of(jsonTags.map((jsonTag) => Tag.fromMap(jsonTag)));
    return tags;
  }

  @override
  Future<BuiltList<Tag>> allFromEntry(int entryId) async {
    final url = Uri.parse(
        _client.baseUrl + Consts.apiPath + '/entries/$entryId/tags.json');
    final resp = await _client.get(url);

    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception(
          "Network Error: ${resp.statusCode}: ${resp.reasonPhrase}");
    }

    final js = jsonDecode(resp.body);
    assert(js is List);
    final jsonTags = js as List;

    final tags = BuiltList.of(jsonTags.map((jsonTag) => Tag.fromMap(jsonTag)));
    return tags;
  }

  @override
  Future<void> removeFromEntry(int entryId, int tagId) async {
    final url = Uri.parse(_client.baseUrl +
        Consts.apiPath +
        '/entries/$entryId/tags/$tagId.json');
    final resp = await _client.delete(url);

    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception(
          "Network Error: ${resp.statusCode}: ${resp.reasonPhrase}");
    }
    return null;
  }
}
