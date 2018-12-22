import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:koalabag/model.dart';
import 'package:koalabag/redux/actions.dart' as act;
import 'package:koalabag/redux/app/state.dart';

class Article extends StatelessWidget {
  final Entry entry;

  Article(this.entry);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Article"),
          ),
          body: SingleChildScrollView(
            child: Html(
              data: entry.content,
              defaultTextStyle: TextStyle(color: Colors.white),
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
