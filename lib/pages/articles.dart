import 'package:flutter/material.dart';

class Articles extends StatelessWidget {
  Articles({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    print("Built Articles");

    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: _appBar(),
            drawer: _drawer(textTheme, context),
            body: TabBarView(children: [
              Center(child: Text("Favorites")),
              Center(child: Text("Unread")),
              Center(child: Text("Archived"))
            ])));
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
