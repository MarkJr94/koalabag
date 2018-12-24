import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:koalabag/consts.dart';
import 'package:koalabag/model.dart';
import 'package:koalabag/data/api.dart';
import 'package:koalabag/data/repository.dart';
import 'package:koalabag/serializers.dart';

class AuthDao implements IAuthDao {
  final IAuthApi _api;

  AuthDao(IAuthApi api) : _api = api;

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
    final auth =
        await _api.login(uri, clientId: clientId, clientSecret: clientSecret);

    final prefs = await SharedPreferences.getInstance();

    final js = serializers.serializeWith(Auth.serializer, auth);

    await prefs.setString(Prefs.auth, jsonEncode(js));
    return auth;
  }

  @override
  Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(Prefs.auth);
  }

  @override
  Future<Auth> refresh(Auth firstAuth) async {
    final auth = await _api.refresh(firstAuth);

    final prefs = await SharedPreferences.getInstance();

    final js = serializers.serializeWith(Auth.serializer, auth);

    await prefs.setString(Prefs.auth, jsonEncode(js));
    return auth;
  }
}
