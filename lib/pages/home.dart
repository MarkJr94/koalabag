import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:koalabag/redux/actions.dart' as act;
import 'package:koalabag/redux/app/state.dart';
import 'package:redux/redux.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, bool>(
      converter: (Store<AppState> store) {
        return store.state.authState == AuthState.good;
      },
      onInit: (store) {
        store.dispatch(act.AuthLocal());
      },
      builder: (context, bool isLoggedIn) {
        print("Home built, isLoggedIn = $isLoggedIn");

        return Scaffold(
          body: Container(
            child: Center(
              child: Text("WELCOME"),
            ),
          ),
        );
      },
      onWillChange: (bool isLoggedIn) {
        if (isLoggedIn) {
          Navigator.of(context).pushReplacementNamed('/articles');
        } else {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      },
    );
  }
}
