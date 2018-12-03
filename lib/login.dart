import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'consts.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: Text("Connect")),
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
  final _clientId = TextEditingController(
      text: "5175_14xfqpdip0dcgc8cswcwsg8sccwgww8kw40sgo84cwgwc8wwkk");
  final _clientSecret = TextEditingController(
      text: "m79rsn12pe88o8ccgw88ggs8coc408gws0w0kg8so44cs4wo0");

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _username.dispose();
    _password.dispose();
    _clientId.dispose();
    _host.dispose();
    _clientSecret.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.all(32.0),
      child: ListView(
        children: <Widget>[
          Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      "Login to Wallabag",
                      style: textTheme.headline,
                    ),
                  ),
                  _buildField(
                      label: "Host",
                      prompt: "hostname (no http/https)",
                      type: TextInputType.text,
                      controller: _host),
                  _buildField(
                      label: "Username",
                      prompt: "Enter username",
                      type: TextInputType.text,
                      controller: _username),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Password"),
                    validator: (value) {
                      if (value.isEmpty) return "Enter password";
                    },
                    keyboardType: TextInputType.text,
                    controller: _password,
                    obscureText: true,
                  ),
                  _buildField(
                      label: "Client ID",
                      prompt: "Enter Client ID",
                      type: TextInputType.text,
                      controller: _clientId),
                  _buildField(
                      label: "Client Secret",
                      prompt: "Enter Client Secret",
                      type: TextInputType.text,
                      controller: _clientSecret),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                      onPressed: () {
                        // Validate will return true if the form is valid, or false if
                        // the form is invalid.
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          _doLogin();
                        }
                      },
                      child: Text('Connect'),
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }

  Widget _buildField({
    @required String label,
    @required String prompt,
    @required TextInputType type,
    @required TextEditingController controller,
  }) {
    return new TextFormField(
      decoration: InputDecoration(labelText: label),
      validator: (value) {
        if (value.isEmpty) return prompt;
      },
      keyboardType: type,
      controller: controller,
    );
  }

  void _doLogin() async {
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Logging in to ${_host.text}')));

    const path = Consts.oauthPath;
    final params = {
      'grant_type': 'password',
      'client_id': _clientId.text,
      'client_secret': _clientSecret.text,
      'username': _username.text,
      'password': _password.text
    };

    final parsedHost = Uri.parse(_host.text);

    final url = Uri(
        scheme: parsedHost.scheme,
        host: parsedHost.host,
        queryParameters: params,
        path: path);
    print("_host.text: ${_host.text}");
    print("parsedHost: $parsedHost, .host: ${parsedHost.host}, .scheme: ${parsedHost.scheme}, .authority: ${parsedHost.authority} ");

    try {
      final auth = await login(url,
          clientId: _clientId.text, clientSecret: _clientSecret.text);

      final prefs = await SharedPreferences.getInstance();

      final json = jsonEncode(auth.toJson());

      await prefs.setString(Prefs.auth, json);

      print("Successful login");
      Navigator.of(context).pushReplacementNamed('/articles');
    } catch (e) {
      print("Error: $e");
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}

class Auth {
  final String accessToken;
  final DateTime expiresAt;
  final String scope;
  final String tokenType;
  final String refreshToken;
  final String clientId;
  final String clientSecret;
  final String origin;

  Auth(
      {this.accessToken,
      this.expiresAt,
      this.scope,
      this.tokenType,
      this.refreshToken,
      this.clientId,
      this.clientSecret,
      this.origin});

  factory Auth.fromNet(Map<String, dynamic> json,
      {String clientId, String clientSecret, String origin}) {
    final expSpan = Duration(seconds: json["expires_in"]);

    return Auth(
        accessToken: json['access_token'],
        expiresAt: DateTime.now().add(expSpan),
        scope: null,
        tokenType: json['token_type'],
        refreshToken: json['refresh_token'],
        clientId: clientId,
        clientSecret: clientSecret,
        origin: origin);
  }

  factory Auth.fromJson(Map<String, dynamic> json) {
    return Auth(
        accessToken: json['accessToken'],
        expiresAt: DateTime.fromMillisecondsSinceEpoch(json['expiresAt']),
        scope: null,
        tokenType: json['tokenType'],
        refreshToken: json['refreshToken'],
        clientId: json['clientId'],
        clientSecret: json['clientSecret'],
        origin: json['origin']);
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'expiresAt': expiresAt.millisecondsSinceEpoch,
      'scope': scope,
      'tokenType': tokenType,
      'refreshToken': refreshToken,
      'clientId': clientId,
      'clientSecret': clientSecret,
      'origin': origin
    };
  }

  bool isExpired() {
    final now = DateTime.now();

    return (expiresAt.compareTo(now) <= 0);
  }
}

Future<Auth> login(Uri uri,
    {@required String clientId, @required String clientSecret}) async {
  print('fetching URI: $uri');
  final resp = await http.get(uri);

  if (resp.statusCode == 200 || resp.statusCode == 302) {
    print(resp.body);
    print(resp.reasonPhrase);
    return Auth.fromNet(json.decode(resp.body), clientSecret: clientSecret, clientId: clientId,
                         origin: uri.scheme + '://' + uri.host);
  } else {
    throw Exception("Network Error: ${resp.statusCode}");
  }
}
