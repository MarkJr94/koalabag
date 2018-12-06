import 'package:koalabag/data/repository.dart';
import 'package:koalabag/model/auth.dart';
import 'package:koalabag/redux/actions.dart' as act;
import 'package:koalabag/redux/state.dart';
import 'package:redux/redux.dart';

class AuthMiddleware extends MiddlewareClass<AppState> {
  final AuthDao _dao;

  AuthMiddleware(this._dao);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) {
    if (action is act.AuthLogin) {
      _dao
          .login(action.uri,
              clientId: action.clientId, clientSecret: action.clientSecret)
          .then((Auth auth) => store.dispatch(act.AuthOk(auth: auth)))
          .catchError((e) => store.dispatch(act.AuthLoginFail(err: e)));
    } else if (action is act.AuthRefresh) {
      _dao
          .refresh(store.state.auth)
          .then((Auth auth) => store.dispatch(act.AuthOk(auth: auth)))
          .catchError((e) => store.dispatch(act.AuthRefreshFail(err: e)));
    } else if (action is act.AuthLocal) {
      _dao
          .loadLocal()
          .then((Auth auth) => store.dispatch(act.AuthOk(auth: auth)))
          .catchError((e) => store.dispatch(act.AuthLocalFail(err: e)));
    } else if (action is act.AuthLogout) {
      _dao
          .logout()
          .then((_) => store.dispatch(act.AuthLogoutOk()))
          .catchError((e) => print("Error logging out??? $e"));
    } else if (action is act.AuthRefreshFail) {
      store.dispatch(act.AuthLogout());
      next(action);
    }

    next(action);
  }
}

class EntryMiddleware extends MiddlewareClass<AppState> {
  EntryDao _dao;

  EntryMiddleware(this._dao);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) {
    // TODO
    if (action is act.LoadEntries) {
      _dao
          .loadEntries()
          .then((entries) => store.dispatch(act.LoadEntriesOk(entries)))
          .catchError((err) => store.dispatch(act.EntriesFail(err)));
    } else if (action is act.FetchEntries) {
      _dao.fetchEntries(store.state.auth).forEach((entries) {
        print("Got ${entries.length} entries");
        store.dispatch(act.FetchEntriesOk(entries));
      }).catchError((err) => store.dispatch(act.EntriesFail(err)));
    } else if (action is act.EntriesFail) {
      print("EntriesFail: ${action.err}");
    } else if (action is act.FetchEntriesOk) {
      _dao
          .mergeSaveEntries(action.entries)
          .then((_) => store.dispatch(act.LoadEntries()))
          .catchError((err) => store.dispatch(act.EntriesFail(err)));
    }

    next(action);
  }
}
