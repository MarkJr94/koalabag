import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart' as http;
import 'package:koalabag/data.dart';
import 'package:koalabag/model.dart';
import 'package:koalabag/pages.dart';
import 'package:koalabag/redux/app/middleware.dart' as mids;
import 'package:koalabag/redux/app/reducer.dart';
import 'package:koalabag/redux/app/state.dart';
import 'package:koalabag/redux/entry.dart';
import 'package:koalabag/consts.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';

void main() async {
  final client = WallaClient(client: http.Client());

  final entryProvider = EntryProvider();
  await entryProvider.open(Consts.dbPath);
  final entryDao = ED(client: client, provider: entryProvider);
  print('entryDao = $entryDao');

//  auth: null, entries: BuiltList(), authState: AuthState.bad

  final store = Store<AppState>(appReducer,
      initialState: AppState((b) => b
        ..isAuthorizing = false
        ..auth.replace(Auth.empty())
        ..authState = AuthState.fetching
        ..entry.replace(EntryState.empty())),
//        ..entry.entries.replace((b) => {})),
      middleware: [
        LoggingMiddleware.printer(),
        mids.AuthMiddleware(RealAuthDao()),
//        mids.EntryMiddleware(entryDao),
      ]..addAll(createEntryMiddle(entryDao)));

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
//    context.get
    return StoreProvider(
        store: store,
        child: MaterialApp(
          title: 'Welcome to Koalabag',
          theme: ThemeData.dark().copyWith(
              primaryColor: Colors.red[500],
              primaryColorDark: Colors.red[900],
              primaryColorLight: Colors.red[100],
              accentColor: Colors.orangeAccent,
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
