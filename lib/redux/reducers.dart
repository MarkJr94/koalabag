import 'package:koalabag/model/auth.dart';
import 'package:koalabag/model/entry.dart';
import 'package:koalabag/redux/actions.dart' as act;
import 'package:koalabag/redux/state.dart';

AppState appReducer(AppState state, action) {
  return new AppState(
    auth: _authReducer(state.auth, action),
    authState: _authStateReducer(state.authState, action),
    entries: _entriesReducer(state.entries, action),
  );
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

List<Entry> _entriesReducer(List<Entry> entries, action) {
  if (action is act.LoadEntriesOk) {
    return action.entries;
  } else {
    return entries;
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
