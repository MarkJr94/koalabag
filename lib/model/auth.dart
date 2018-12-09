import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'auth.g.dart';

abstract class Auth implements Built<Auth, AuthBuilder> {
  static Serializer<Auth> get serializer => _$authSerializer;

  @BuiltValueField(wireName: 'access_token')
  String get accessToken;

  @BuiltValueField(wireName: 'expires_in')
  int get expiresIn;

  @nullable
  String get scope;

  @BuiltValueField(wireName: 'token_type')
  String get tokenType;

  @BuiltValueField(wireName: 'refresh_token')
  String get refreshToken;

  @BuiltValueField(wireName: 'client_id')
  String get clientId;

  @BuiltValueField(wireName: 'client_secret')
  String get clientSecret;

  String get origin;

  Auth._();

  factory Auth([updates(AuthBuilder b)]) = _$Auth;

  factory Auth.empty() {
    return _$Auth._(
        accessToken: '',
        expiresIn: 0,
        scope: '',
        tokenType: '',
        refreshToken: '',
        clientId: '',
        clientSecret: '',
        origin: '');
  }
}
