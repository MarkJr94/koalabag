import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:koalabag/redux/app/state.dart';
import 'package:koalabag/redux/entry.dart';
import 'package:koalabag/ui.dart';
import 'package:koalabag/model.dart';

class Articles extends StatefulWidget {
  @override
  State<Articles> createState() {
    // TODO: implement createState
    return ArticleState();
  }
}

class ArticleState extends State<Articles> {
  final int Function(Entry, Entry) sortOld =
      (a, b) => a.createdAt.compareTo(b.createdAt);

  final int Function(Entry, Entry) sortRecent =
      (a, b) => b.createdAt.compareTo(a.createdAt);

  int Function(Entry, Entry) currentSort;

  ArticleState() {
    currentSort = sortRecent;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final textTheme = Theme.of(context).textTheme;
    print("Built Articles");
    return DefaultTabController(
        length: 3,
        initialIndex: 1,
        child: Scaffold(
            appBar: _appBar(),
            drawer: _drawer(textTheme, context),
            body: Builder(builder: (context) {
              return TabBarView(
                children: [
                  _list("Favorites", context, (e) => e.starred()),
                  _list("Unread", context, (e) => !e.archived()),
                  _list("Archived", context, (e) => e.archived()),
                ],
              );
            }),
            floatingActionButton: Builder(builder: (context) {
              return StoreConnector<AppState, VoidCallback>(
                converter: (store) {
                  return () async {
                    final Uri uri =
                        await Navigator.of(context).push(MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (context) {
                              return AddEntryDialog();
                            }));

                    if (null != uri) {
                      store.dispatch(AddEntry(uri: uri));
                    }
                  };
                },
                builder: (context, callback) {
                  return FloatingActionButton(
                      child: Icon(Icons.add), onPressed: callback);
                },
                onInit: (store) {
                  store.dispatch(LoadEntries());
                },
              );
            })));
  }

  EntryList _list(
      final String title, BuildContext context, bool Function(Entry) filter) {
    return EntryList(
      key: UniqueKey(),
      filter: filter,
      sort: currentSort,
    );
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
//        text: text,
        icon: Icon(icon),
      );
    };

    return AppBar(
      title: Text("Articles"),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: search,
        ),
        IconButton(icon: Icon(Icons.sort), onPressed: flipSort),
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

  void flipSort() {
    print("flipSort");
    setState(() {
      if (currentSort == sortRecent) {
        currentSort = sortOld;
      } else {
        currentSort = sortRecent;
      }
    });
  }

  void search() {
    showSearch(
      context: context,
      delegate: EntrySearchDelegate(),
    );
  }
}

class EntrySearchDelegate extends SearchDelegate<Entry> {
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          this.close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return EntrySearch(
      query,
      isSearch: true,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    print("buildsuggestions: query = $query");
    // TODO: implement buildSuggestions
    return Center(
      child: Text(
        "Search: $query",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme;
  }
}
