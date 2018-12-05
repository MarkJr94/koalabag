import 'package:flutter/material.dart';
import 'package:koalabag/model/auth.dart';

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
}
