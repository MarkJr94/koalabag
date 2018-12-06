import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'auth.g.dart';

abstract class Auth implements Built<Auth, AuthBuilder> {
  static Serializer<Auth> get serializer => _$authSerializer;

  String get access_token;

  int get expires_in;

  @nullable
  String get scope;

  String get token_type;

  String get refresh_token;

  String get client_id;

  String get client_secret;

  String get origin;

  Auth._();

  factory Auth([updates(AuthBuilder b)]) = _$Auth;
}
