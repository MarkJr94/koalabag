import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: const Text("Connect")),
        body: new LoginForm());
  }
}

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() {
    return new LoginState();
  }
}

class LoginState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  final _username = TextEditingController();
  final _password = TextEditingController();
  final _host = TextEditingController(text: "https://app.wallabag.it");
  final _clientId = TextEditingController();
  final _clientSecret = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _username.dispose();
    _password.dispose();
    _host.dispose();
    _clientId.dispose();
    _clientSecret.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildField(
                    "Host", "Please enter a URL", TextInputType.url, _host),
                _buildField("Username", "Please enter a username",
                    TextInputType.text, _username),
                _buildField("Password", "Enter password", TextInputType.text,
                    _password), // TODO Password input
                _buildField("Client ID", "Enter Client ID", TextInputType.text,
                    _clientId),
                _buildField("Client Secret", "Enter Client Secret",
                    TextInputType.text, _clientSecret),
                new Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                      onPressed: () {
                        // Validate will return true if the form is valid, or false if
                        // the form is invalid.
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          _doLogin();
                        }
                      },
                      child: Text('Submit'),
                    ),
                  ),
                ),
              ],
            ))
      ],
    );
  }

  Widget _buildField(String label, String prompt, TextInputType type,
      TextEditingController controller) {
    return new TextFormField(
      decoration: InputDecoration(labelText: label),
      validator: (value) {
        if (value.isEmpty) return prompt;
      },
      keyboardType: type,
      controller: controller,
    );
  }

  void _doLogin() {
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Logging in to ${_host.text}')));

    final url = Uri.https(_host.text, "/oauth/v2/token", {
      'grant_type': 'password',
      'client_id': _clientId.text,
      'client_secret': _clientSecret.text,
      'username': _username.text,
      'password': _password.text
    });



    final auth = login(url);
    auth.then((auth) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Success!!!')));
    }).catchError((err) =>
        Scaffold.of(context).showSnackBar(SnackBar(content: Text(err.toString()))));
  }
}

class Auth {
  final String accessToken;
  final int expiresIn;
  final String scope;
  final String tokenType;
  final String refreshToken;

  Auth(
      {this.accessToken,
      this.expiresIn,
      this.scope,
      this.tokenType,
      this.refreshToken});

  factory Auth.fromJson(Map<String, dynamic> json) {
    return Auth(
        accessToken: json['access_token'],
        expiresIn: json['expires_in'],
        scope: null,
        tokenType: json['token_type'],
        refreshToken: json['refresh_token']);
  }
}

Future<Auth> login(Uri uri) async {
  print('fetching URI: $uri');
  final resp = await http.get(uri);

  if (resp.statusCode == 200 || resp.statusCode == 302) {
    print(resp.body);
    print(resp.reasonPhrase);
    return Auth.fromJson(json.decode(resp.body));
  } else {
    throw Exception("Network Error: ${resp.statusCode}");
  }
}
