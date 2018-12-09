import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:koalabag/model/auth.dart';
import 'package:koalabag/redux/entry.dart';

part 'state.g.dart';

class AuthState extends EnumClass {
  /// Example of how to make an [EnumClass] serializable.
  ///
  /// Declare a static final [Serializers] field called `serializer`.
  /// The built_value code generator will provide the implementation. You need
  /// to do this for every type you want to serialize.
  static Serializer<AuthState> get serializer => _$authStateSerializer;

  static const AuthState fetching = _$fetching;
  static const AuthState good = _$good;
  static const AuthState bad = _$bad;

  const AuthState._(String name) : super(name);

  static BuiltSet<AuthState> get values => _$values;
  static AuthState valueOf(String name) => _$valueOf(name);
}

abstract class AppState implements Built<AppState, AppStateBuilder> {
  static Serializer<AppState> get serializer => _$appStateSerializer;

  @nullable
  Auth get auth;

  bool get isAuthorizing;

  AuthState get authState;

  @nullable
  EntryState get entry;

  AppState._();

  factory AppState([updates(AppStateBuilder b)]) = _$AppState;
}
