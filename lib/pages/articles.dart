import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:koalabag/redux/actions.dart' as act;
import 'package:koalabag/redux/state.dart';
import 'package:koalabag/ui.dart';
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
          distinct: true,
          converter: _ViewModel.fromStore,
          builder: (context, vm) {
            return Scaffold(
              appBar: _appBar(
                  onRefresh: () => vm.refresh(), onSync: () => vm.fetch()),
              drawer: _drawer(textTheme, context),
              body: Builder(builder: (context) {
                return TabBarView(children: [
                  _list("Favorites", vm, context, (e) => e.isStarred()),
                  _list("Unread", vm, context, (e) => !e.isArchived()),
                  _list("Archived", vm, context, (e) => e.isArchived()),
                ]);
              }),
              floatingActionButton: Builder(builder: (context) {
                return FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("Unimplemented!"),
                        backgroundColor: Colors.deepPurple,
                        duration: Duration(milliseconds: 500),
                      ));
//                    vm.fetch();
//                      vm.store.
                    });
              }),
            );
          },
          onWillChange: (vm) {
            print('Articles onWillChange');
          },
        ));
  }

  EntryList _list(final String title, final _ViewModel vm, BuildContext context,
      bool Function(Entry) filter) {
    final noOp = (idx, entry) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Unimplemented!"),
        backgroundColor: Colors.deepPurple,
        duration: Duration(milliseconds: 500),
      ));
    };

    // TODO
    final EntryListHolder eh = EntryListHolder(
        onStar: noOp,
        onCheck: noOp,
        onDelete: noOp,
        onRefresh: () => Future.sync(() => vm.fetch()));
    return EntryList(
        entries: BuiltList.of(vm.store.state.entries.where(filter)),
        listener: eh);
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

  Widget _appBar(
      {@required VoidCallback onRefresh, @required VoidCallback onSync}) {
    final mkTab = ({String text, IconData icon}) {
      return Tab(
        text: text,
        icon: Icon(icon),
      );
    };

    return AppBar(
      title: Text("Articles"),
      actions: <Widget>[
        IconButton(icon: Icon(Icons.refresh), onPressed: onRefresh),
        IconButton(icon: Icon(Icons.sync), onPressed: onSync),
      ],
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
  final BuiltList<int> entryIds;

  _ViewModel({@required this.store, @required this.entryIds});

  static _ViewModel fromStore(Store<AppState> store) {
    final list = BuiltList.of(store.state.entries.map((e) => e.id));
    return _ViewModel(store: store, entryIds: list);
  }

  void fetch() {
    store.dispatch(act.FetchEntries());
  }

  void refresh() {
    store.dispatch(act.AuthRefresh());
  }

  Entry hydrate(final int id) {
    return store.state?.entries?.firstWhere((e) => e.id == id);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          entryIds == other.entryIds;

  @override
  int get hashCode => entryIds.hashCode;
}
