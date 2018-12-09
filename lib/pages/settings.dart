import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:koalabag/redux/actions.dart' as act;
import 'package:koalabag/redux/app/state.dart';
import 'package:redux/redux.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Settings"),
          ),
          body: Container(
            child: ListView(
              children: <Widget>[
                RaisedButton(
                  child: Text("Logout"),
                  color: Colors.redAccent,
                  onPressed: () {
                    vm.logout();
                  },
                )
              ],
            ),
          ),
        );
      },
      onWillChange: (vm) {
        if (!vm.loggedIn) {
          Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
        }
      },
    );
  }
}

class _ViewModel {
  final VoidCallback logout;
  final bool loggedIn;

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
        loggedIn: store.state.authState == AuthState.good,
        logout: () => store.dispatch(act.AuthLogout()));
  }

  _ViewModel({@required this.logout, @required this.loggedIn});
}
