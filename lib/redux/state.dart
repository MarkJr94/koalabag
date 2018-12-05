import 'package:koalabag/model/auth.dart';
import 'package:koalabag/model/entry.dart';
import 'package:meta/meta.dart';


@immutable
class AppState {
  final Auth auth;
  final AuthState authState;

  final List<Entry> entries;

  AppState({this.auth, this.entries, this.authState});

  AppState copyWith({Auth auth, List<Entry> entries, AuthState authstate}) {
    return AppState(
        auth: auth ?? this.auth,
        entries: entries ?? this.entries,
        authState: authstate ?? this.authState);
  }

  @override
  String toString() {
    return 'AppState { auth: $auth, entries: $entries, authState: $authState }';
  }
}

enum AuthState {
  fetching,
  good,
  bad,
}


