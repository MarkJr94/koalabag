import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';

import 'package:koalabag/data.dart';
import 'package:koalabag/model.dart';
import 'package:koalabag/data/api.dart';
import 'package:koalabag/pages.dart';
import 'package:koalabag/redux/app/middleware.dart' as mids;
import 'package:koalabag/redux/app/reducer.dart';
import 'package:koalabag/redux/app/state.dart';
import 'package:koalabag/redux/entry.dart';

const dbPath = 'koalabag.db';
const dbVersion = 1;

void main() async {
  final client = WallaClient(http.Client());

  final provider = await Provider.open(dbPath, version: dbVersion);

  var tagApi = TagApi(client);
  final tagProvider = provider.tagProvider;
  final tagToEntryProvider = provider.tagToEntryProvider;
  final tagDao = TagDao(tagApi, tagProvider, tagToEntryProvider);

  final entryInfoProvider = provider.entryInfoProvider;
  final entryContentProvider = provider.entryContentProvider;
  final entryDao = EntryDao(
      api: EntryApi(client),
      tagApi: tagApi,
      infoProvider: entryInfoProvider,
      contentProvider: entryContentProvider,
      tagProvider: tagProvider,
      tagToEntryProvider: tagToEntryProvider);
  print('entryDao = $entryDao');

  final authDao = AuthDao(AuthApi());
  final dao = Dao(authDao: authDao, entryDao: entryDao, tagDao: tagDao);

  Global().init(dao);

  final store = Store<AppState>(appReducer,
      initialState: AppState((b) => b
        ..isAuthorizing = false
        ..auth.replace(Auth.empty())
        ..authState = AuthState.fetching
        ..entry.replace(EntryState.empty())),
      middleware: [
        LoggingMiddleware.printer(),
        mids.AuthMiddleware(authDao),
      ]..addAll(createEntryMiddle(entryDao)));

  store.dispatch(LoadEntries());

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
