import 'package:flutter/material.dart';

import 'articles.dart';
import 'login.dart';
import 'splash.dart';

void main() async {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Koalabag',
      theme: ThemeData(
          primaryColor: Colors.red,
          accentColor: Colors.pinkAccent,
          brightness: Brightness.dark),
      home: Splash(),
      routes: <String, WidgetBuilder>{

//      '/': (BuildContext context ) => Splash(),
        '/articles': (BuildContext context) => Articles(),
        '/login': (BuildContext context) => LoginPage()
      },
    );
  }
}