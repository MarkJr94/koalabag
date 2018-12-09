import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:koalabag/consts.dart';
import 'package:koalabag/redux/actions.dart' as act;
import 'package:koalabag/redux/app/state.dart';
import 'package:redux/redux.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Connect"),
        ),
        body: Builder(builder: (context) {
          return StoreConnector<AppState, _ViewModel>(
            distinct: true,
            converter: (Store<AppState> store) {
              return _ViewModel(
                  authState: store.state.authState,
                  loggedIn: store.state.authState == AuthState.good,
                  store: store);
            },
            builder: (context, vm) {
              return LoginForm(vm: vm);
            },
            onWillChange: (vm) {
              if (vm.authState == AuthState.good) {
                Navigator.pushReplacementNamed(context, '/articles');
              } else if (vm.authState == AuthState.bad) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Logging in failed'),
                  backgroundColor: Colors.redAccent,
                ));
              }
            },
          );
        }));
  }
}

class LoginForm extends StatefulWidget {
  final _ViewModel vm;

  const LoginForm({Key key, @required this.vm}) : super(key: key);

  @override
  State<LoginForm> createState() {
    return new LoginState(dispatchLogin: vm.dispatchLogin);
  }
}

class LoginState extends State<LoginForm> {
  final Function dispatchLogin;

  final _formKey = GlobalKey<FormState>();

  final _username = TextEditingController();
  final _password = TextEditingController();
  final _host = TextEditingController(text: "https://app.wallabag.it");
  final _clientId = TextEditingController(
      text: "5175_14xfqpdip0dcgc8cswcwsg8sccwgww8kw40sgo84cwgwc8wwkk");
  final _clientSecret = TextEditingController(
      text: "m79rsn12pe88o8ccgw88ggs8coc408gws0w0kg8so44cs4wo0");
  bool _obscurePassword = true;

  LoginState({@required this.dispatchLogin});

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
        children: <Widget>[_buildForm(textTheme)],
      ),
    );
  }

  Form _buildForm(TextTheme textTheme) {
    return Form(
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: "Password"),
                    validator: (value) {
                      if (value.isEmpty) return "Enter password";
                    },
                    keyboardType: TextInputType.text,
                    controller: _password,
                    obscureText: _obscurePassword,
                  ),
                ),
                IconButton(
                    icon: Icon(
                        _obscurePassword ? Icons.remove_red_eye : Icons.lock),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    })
              ],
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
        ));
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
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('Logging in to ${_host.text}'),
      backgroundColor: Colors.yellow,
    ));

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
    final action = act.AuthLogin(
        uri: url, clientId: _clientId.text, clientSecret: _clientSecret.text);
    dispatchLogin(action);
  }
}

class _ViewModel {
  final bool loggedIn;
  final AuthState authState;
  final Store<AppState> store;

  _ViewModel(
      {@required this.loggedIn,
      @required this.authState,
      @required this.store});

  void dispatchLogin(act.AuthLogin login) {
    store.dispatch(login);
  }

  @override
  String toString() {
    return '_ViewModel{loggedIn: $loggedIn, authState: $authState, store: $store}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
//          store == other.store &&
          loggedIn == other.loggedIn &&
          authState == other.authState;

  @override
  int get hashCode => loggedIn.hashCode ^ authState.hashCode;
}
