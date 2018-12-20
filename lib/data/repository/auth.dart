import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:koalabag/consts.dart';
import 'package:koalabag/model.dart';
import 'package:koalabag/data/repository.dart';
import 'package:koalabag/serializers.dart';

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
