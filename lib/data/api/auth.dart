import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:koalabag/consts.dart';
import 'package:koalabag/model.dart';
import 'package:koalabag/data/api.dart';
import 'package:koalabag/serializers.dart';

class AuthApi implements IAuthApi {
  @override
  Future<Auth> login(Uri uri, {String clientId, String clientSecret}) async {
    print('login uri = $uri');
    final resp = await http.get(uri);

    if (resp.statusCode == 200 || resp.statusCode == 302) {
      Map<String, dynamic> js = json.decode(resp.body);

      js['client_id'] = clientId;
      js['client_secret'] = clientSecret;
      js['origin'] = uri.scheme + '://' + uri.host;

      print('js = $js');

      final auth = serializers.deserializeWith(Auth.serializer, js);

      print('auth = $auth');
      return auth;
    } else {
      throw Exception("Network Error: ${resp.statusCode}");
    }
  }

  @override
  Future<Auth> refresh(Auth old) async {
    final params = {
      'grant_type': 'refresh_token',
      'client_id': old.clientId,
      'client_secret': old.clientSecret,
      'refresh_token': old.refreshToken,
    };

    final uri = Uri.parse(old.origin).replace(path: Consts.oauthPath);

    final resp = await http.post(uri, body: params);

    print("refresh  resp { status: ${resp.statusCode}, body: ${resp.body}");

    if (resp.statusCode == 200 || resp.statusCode == 302) {
      Map<String, dynamic> js = json.decode(resp.body);

      js['client_id'] = old.clientId;
      js['client_secret'] = old.clientSecret;
      js['origin'] = uri.scheme + '://' + uri.host;

      final auth = serializers.deserializeWith(Auth.serializer, js);

      return auth;
    } else {
      throw Exception("Network Error: ${resp.statusCode}");
    }
  }
}
