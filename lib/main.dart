import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart' as http;
import 'package:koalabag/data/repository.dart';
import 'package:koalabag/pages/articles.dart';
import 'package:koalabag/pages/login.dart';
import 'package:koalabag/pages/settings.dart';
import 'package:koalabag/pages/home.dart';
import 'package:koalabag/redux/middlewares.dart' as mids;
import 'package:koalabag/redux/reducers.dart';
import 'package:koalabag/redux/state.dart';
import 'package:koalabag/model/entry.dart';
import 'package:koalabag/consts.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';

void main() async {
  final client = WallaClient(client: http.Client());

  final entryProvider = EntryProvider();
  await entryProvider.open(Consts.dbPath);
  final entryDao = ED(client: client, provider: entryProvider);
  print('entryDao = $entryDao');

  final store = Store<AppState>(appReducer,
      initialState:
          AppState(auth: null, entries: List(), authState: AuthState.bad),
      middleware: [
        LoggingMiddleware.printer(),
        mids.AuthMiddleware(RealAuthDao()),
        mids.EntryMiddleware(entryDao),
      ]);

  client.store = store;
  runApp(MyApp(
    store: store,
  ));
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
