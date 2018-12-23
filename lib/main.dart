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

class Global {
  static final Global _singleton = new Global._internal();
  Dao _dao;

  factory Global() {
    return _singleton;
  }

  Global._internal() {
//    ... // initialization logic here
  }

  void init(Dao dao) {
    _dao = dao;
  }

  get dao {
    return _dao;
  }

//  ... // rest of the class
}

void main() async {
  final client = WallaClient(client: http.Client());

  final entryProvider = EntryProvider();
  await entryProvider.open(Consts.dbPath);
  final entryDao = EntryDao(client: client, provider: entryProvider);
  print('entryDao = $entryDao');

  final realAuthDao = RealAuthDao();
  final dao = Dao(authDao: realAuthDao, entryDao: entryDao);

  Global().init(dao);

  final store = Store<AppState>(appReducer,
      initialState: AppState((b) => b
        ..isAuthorizing = false
        ..auth.replace(Auth.empty())
        ..authState = AuthState.fetching
        ..entry.replace(EntryState.empty())),
      middleware: [
        LoggingMiddleware.printer(),
        mids.AuthMiddleware(realAuthDao),
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
