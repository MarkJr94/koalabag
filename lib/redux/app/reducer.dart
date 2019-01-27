import 'package:koalabag/model/auth.dart';
import 'package:koalabag/redux/actions.dart' as act;
import 'package:koalabag/redux/app/state.dart';
import 'package:koalabag/redux/entry.dart';
import 'package:koalabag/redux/tag.dart';

AppState appReducer(AppState state, action) {
  return state.rebuild((b) => b
    ..auth.replace(_authReducer(state.auth, action))
    ..isAuthorizing = _isAuthingReducer(state.isAuthorizing, action)
    ..authState = _authStateReducer(state.authState, action)
    ..entry.replace(entryReducer(state.entry, action))
    ..tag.replace(tagReducer(state.tag, action)));
}

AuthState _authStateReducer(AuthState authState, final action) {
  if (action is act.AuthReq) {
    return AuthState.fetching;
  } else if (action is act.AuthOk) {
    return AuthState.good;
  } else if (action is act.AuthFail) {
    print("AuthFail: ${action.err}");
    return AuthState.bad;
  } else if (action is act.AuthLogoutOk) {
    return AuthState.bad;
  } else {
    return authState;
  }
}

Auth _authReducer(Auth auth, action) {
  if (action is act.AuthOk) {
    return action.auth;
  } else if (action is act.AuthLogoutOk) {
    return null;
  }

  return auth;
}

bool _isAuthingReducer(bool isAuthing, final action) {
  if (action is act.AuthReq) {
    return true;
  } else if (action is act.AuthOk || action is act.AuthFail) {
    return false;
  }

  return isAuthing;
}
