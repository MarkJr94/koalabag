import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:koalabag/redux/actions.dart' as act;
import 'package:koalabag/redux/state.dart';
import 'package:koalabag/model.dart';
import 'package:redux/redux.dart';

class Articles extends StatelessWidget {
  Articles({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    print("Built Articles");

    return DefaultTabController(
        length: 3,
        child: StoreConnector<AppState, _ViewModel>(
          converter: _ViewModel.fromStore,
          builder: (context, vm) {
            return Scaffold(
              appBar: _appBar(),
              drawer: _drawer(textTheme, context),
              body: TabBarView(children: [
                _body("Favorites", vm),
                _body("Unread", vm),
                _body("Archived", vm),
              ]),
              floatingActionButton: Builder(builder: (context) {
                return FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("Unimplemented!"),
                        backgroundColor: Colors.deepPurple,
                      ));
//                    vm.fetch();
//                      vm.store.
                    });
              }),
            );
          },
          ignoreChange: (_) => false,
        ));
  }

  Widget _body(final String title, final _ViewModel vm) {
    return ListView.builder(
        itemCount: (vm.entries?.length ?? 1) + 1,
        itemBuilder: (context, idx) {
          if (idx == 0) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RaisedButton(
                  onPressed: () => vm.refresh(),
                  child: Text("Refresh Auth"),
                ),
                Text(title),
                RaisedButton(
                  onPressed: () => vm.fetch(),
                  child: Text("Fetch Articles"),
                )
              ],
            );
          } else {
            if (vm.entries != null) {
              final entry = vm.entries[idx - 1];
              return EntryTile(
                entry: entry,
                key: ValueKey(entry.id),
              );
            }
          }
        });
  }

  Drawer _drawer(TextTheme theme, BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the Drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  'Koalabag',
                  style: theme.display1.apply(color: Colors.white),
                )
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.redAccent,
            ),
          ),
          ListTile(
            title: Text('Articles'),
            leading: Icon(Icons.assignment),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: Text('Settings'),
            leading: Icon(Icons.settings),
            onTap: () => _pushSettings(context),
          ),
          ListTile(
            title: Text("About"),
            leading: Icon(Icons.help_outline),
          )
        ],
      ),
    );
  }

  Widget _appBar() {
    final mkTab = ({String text, IconData icon}) {
      return Tab(
        text: text,
        icon: Icon(icon),
      );
    };

    return AppBar(
      title: Text("Articles"),
      bottom: TabBar(
        tabs: <Widget>[
          mkTab(text: "Favorites", icon: Icons.star),
          mkTab(text: "Unread", icon: Icons.markunread),
          mkTab(text: "Archived", icon: Icons.archive),
        ],
      ),
    );
  }

  void _pushSettings(BuildContext context) {
    Navigator.of(context).pushNamed('/settings');
  }
}

class _ViewModel {
  final Store<AppState> store;
  final List<Entry> entries;

  _ViewModel({@required this.store, @required this.entries});

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(store: store, entries: store.state.entries);
  }

  void fetch() {
    store.dispatch(act.FetchEntries());
  }

  void refresh() {
    store.dispatch(act.AuthRefresh());
  }
}

class EntryTile extends StatelessWidget {
  final Entry entry;

  const EntryTile({Key key, @required this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    // TODO: implement build
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          entry.title,
          style: tt.body1,
        ),
        Text(
          "${entry.reading_time} min",
          style: tt.caption,
        )
      ],
    );
  }
}
