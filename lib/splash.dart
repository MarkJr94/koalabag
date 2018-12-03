import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'consts.dart';
import 'login.dart';

class Splash extends StatefulWidget {
  @override
  State<Splash> createState() {
    return SplashState();
  }
}

class SplashState extends State<Splash> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text("WELCOME"),
          ),
        ),
    );
  }

  @override
  void initState() {
    super.initState();
    checkAuth();
  }

  void checkAuth() async {
    getAuth().then((au) {
      if (au != null) {
        print("Good auth");
        Navigator.of(context).pushReplacementNamed('/articles');
      } else {
        print("Bad auth");
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }).catchError((e) {
      print("Auth Error: $e");
      Navigator.of(context).pushReplacementNamed('/login');
    });
  }

  Future<Auth> getAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonDecode(prefs.getString(Prefs.auth));
    final auth = Auth.fromJson(json);
    return auth;
  }
}
