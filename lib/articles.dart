import 'package:flutter/material.dart';

class Articles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    print("Built articles");

    return Scaffold(
        appBar: AppBar(title: Text("Articles")),
        drawer: _drawer(textTheme),
        body: Container(
          child: Center(
              child: Text(
            "FOOOH",
            style: textTheme.headline,
          )),
        ));
  }

  Drawer _drawer(TextTheme theme) {
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
                Text('Koalabag', style: theme.display1.apply(color: Colors.white),)
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
              // Update the state of the app
              // ...
            },
          ),
          ListTile(
            title: Text('Settings'),
            leading: Icon(Icons.settings),
            onTap: () {
              // Update the state of the app
              // ...
            },
          ),
          ListTile(
            title: Text("About"),
            leading: Icon(Icons.help_outline),
          )
        ],
      ),
    );
  }
}
