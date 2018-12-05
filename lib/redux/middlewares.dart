import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:koalabag/consts.dart';
import 'package:koalabag/model/auth.dart';
import 'package:koalabag/redux/actions.dart' as act;
import 'package:koalabag/redux/state.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

void authMiddleWares(Store<AppState> store, action, NextDispatcher next) {
  // If our Middleware encounters a `FetchTodoAction`
  if (action is act.AuthLogin) {
    _login(action.uri,
            clientId: action.clientId, clientSecret: action.clientSecret)
        .then((Auth auth) => store.dispatch(act.AuthOk(auth: auth)))
        .catchError((e) => store.dispatch(act.AuthLoginFail(err: e)));
  } else if (action is act.AuthRefresh) {
    _refresh(store.state.auth)
        .then((Auth auth) => store.dispatch(act.AuthOk(auth: auth)))
        .catchError((e) => store.dispatch(act.AuthRefreshFail(err: e)));
  } else if (action is act.AuthLocal) {
    _loadLocal()
        .then((Auth auth) => store.dispatch(act.AuthOk(auth: auth)))
        .catchError((e) => store.dispatch(act.AuthLocalFail(err: e)));
  } else if (action is act.AuthLogout) {
    _logout()
        .then((_) => store.dispatch(act.AuthLogoutOk()))
        .catchError((e) => print("Error logging out??? $e"));
  }

  // Make sure our actions continue on to the reducer.
  next(action);
}
Future<Auth> _login(Uri uri,
    {@required String clientId, @required String clientSecret}) async {
  final resp = await http.get(uri);

  if (resp.statusCode == 200 || resp.statusCode == 302) {
    final auth = Auth.fromNet(json.decode(resp.body),
        clientSecret: clientSecret,
        clientId: clientId,
        origin: uri.scheme + '://' + uri.host);

    final prefs = await SharedPreferences.getInstance();
    final js = jsonEncode(auth.toJson());
    await prefs.setString(Prefs.auth, js);
    return auth;
  } else {
    throw Exception("Network Error: ${resp.statusCode}");
  }
}

Future<Auth> _refresh(Auth auth) async {
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
    final newAuth = Auth.fromNet(json.decode(resp.body),
        clientSecret: auth.clientSecret,
        clientId: auth.clientId,
        origin: uri.scheme + '://' + uri.host);

    final prefs = await SharedPreferences.getInstance();
    final js = jsonEncode(auth.toJson());
    await prefs.setString(Prefs.auth, js);

    return newAuth;
  } else {
    throw Exception("Network Error: ${resp.statusCode}");
  }
}

Future<Auth> _loadLocal() async {
  final prefs = await SharedPreferences.getInstance();
  final json = jsonDecode(prefs.getString(Prefs.auth));
  final auth = Auth.fromJson(json);
  return auth;
}

Future<bool> _logout() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.remove(Prefs.auth);
}
