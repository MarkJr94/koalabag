import 'package:koalabag/data/repository.dart';
import 'package:koalabag/model.dart';
import 'package:koalabag/redux/actions.dart' as act;
import 'package:koalabag/redux/app/state.dart';
import 'package:redux/redux.dart';

class AuthMiddleware extends MiddlewareClass<AppState> {
  final AuthDao _dao;

  AuthMiddleware(this._dao);

  @override
  void call(Store<AppState> store, action, NextDispatcher next) {
    // Ignore requests if current one in progress
    if (store.state.isAuthorizing && action is act.AuthReq) {
      print("Ignoring auth request: $action");
//      next(action);
      return;
    }

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
    }

    next(action);
  }
}
