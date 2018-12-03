import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../consts.dart';
import '../login.dart';

/// A class similar to http.Response but instead of a String describing the body
/// it already contains the parsed Dart-Object
class ParsedResponse<T> {
  ParsedResponse(this.statusCode, this.body);

  final int statusCode;
  final T body;

  bool isOk() {
    return statusCode >= 200 && statusCode < 300;
  }
}

class Repository {
  static Repository _repo;

  Auth auth;

//  BookDatabase database;

  Repository._internal({@required this.auth});

  static Repository init(Auth auth) {
    _repo = Repository._internal(auth: auth);
    return _repo;
  }

  static Repository get() {
    return _repo;
  }

  void refresh() async  {
    auth = await _refresh(auth);
  }

  static Future<Auth> _refresh(Auth auth) async {
    final params = {
      'grant_type': 'refresh',
      'client_id': auth.clientId,
      'client_secret': auth.clientSecret,
      'refresh_token': auth.refreshToken,
    };

    final parsed = Uri.parse(auth.origin);
    final uri = Uri(
        scheme: parsed.scheme,
        host: parsed.host,
        path: Consts.oauthPath,
        queryParameters: params);

    final resp = await http.get(uri);

    if (resp.statusCode == 200 || resp.statusCode == 302) {
      print(resp.body);
      print(resp.reasonPhrase);
      return Auth.fromNet(json.decode(resp.body), clientSecret: auth.clientSecret, clientId: auth.clientId,
                               origin: uri.scheme + '://' + uri.host);
    } else {
      throw Exception("Network Error: ${resp.statusCode}");
    }
  }
}
