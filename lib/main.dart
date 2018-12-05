import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:koalabag/pages/articles.dart';
import 'package:koalabag/pages/login.dart';
import 'package:koalabag/pages/settings.dart';
import 'package:koalabag/pages/splash.dart';
import 'package:koalabag/redux/middlewares.dart' as mids;
import 'package:koalabag/redux/reducers.dart';
import 'package:koalabag/redux/state.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';

void main() {
  final store = Store<AppState>(appReducer,
      initialState:
          AppState(auth: null, entries: List(), authState: AuthState.bad),
      middleware: [
        LoggingMiddleware.printer(),
        mids.authMiddleWares,
      ]);
  runApp(MyApp(store: store,));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  MyApp({Key key, @required this.store});

  @override
  Widget build(BuildContext context) {

    return StoreProvider(
        store: store,
        child: MaterialApp(
          title: 'Welcome to Koalabag',
          theme: ThemeData(
              primaryColor: Colors.red,
              accentColor: Colors.pinkAccent,
              brightness: Brightness.dark),
          home: Home(),
          routes: <String, WidgetBuilder>{
            '/articles': (BuildContext context) => Articles(),
            '/login': (BuildContext context) => LoginPage(),
            '/settings': (BuildContext context) => Settings(),
          },
        ));
  }
}
