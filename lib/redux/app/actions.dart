import 'package:koalabag/model/auth.dart';
import 'package:meta/meta.dart';

class AuthOk {
  final Auth auth;

  AuthOk({@required this.auth});
}

class AuthReq {}

class AuthFail {
  final dynamic err;

  AuthFail({@required this.err});
}

class AuthLogout {}

class AuthLogoutOk {}

// Remote Auth
class AuthLogin extends AuthReq {
  final Uri uri;
  final String clientId, clientSecret;

  AuthLogin(
      {@required this.uri,
      @required this.clientId,
      @required this.clientSecret});
}

class AuthLoginFail extends AuthFail {
  AuthLoginFail({@required err}) : super(err: err);
}

// Getting auth from prefs
class AuthLocal extends AuthReq {}

class AuthLocalFail extends AuthFail {
  AuthLocalFail({@required err}) : super(err: err);
}

// Refreshing auth
class AuthRefresh extends AuthReq {}

class AuthRefreshFail extends AuthFail {
  AuthRefreshFail({@required err}) : super(err: err);
}
