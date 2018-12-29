// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line
// ignore_for_file: annotate_overrides
// ignore_for_file: avoid_annotating_with_dynamic
// ignore_for_file: avoid_catches_without_on_clauses
// ignore_for_file: avoid_returning_this
// ignore_for_file: lines_longer_than_80_chars
// ignore_for_file: omit_local_variable_types
// ignore_for_file: prefer_expression_function_bodies
// ignore_for_file: sort_constructors_first
// ignore_for_file: unnecessary_const
// ignore_for_file: unnecessary_new
// ignore_for_file: test_types_in_equals

Serializer<Auth> _$authSerializer = new _$AuthSerializer();

class _$AuthSerializer implements StructuredSerializer<Auth> {
  @override
  final Iterable<Type> types = const [Auth, _$Auth];
  @override
  final String wireName = 'Auth';

  @override
  Iterable serialize(Serializers serializers, Auth object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'access_token',
      serializers.serialize(object.accessToken,
          specifiedType: const FullType(String)),
      'expires_in',
      serializers.serialize(object.expiresIn,
          specifiedType: const FullType(int)),
      'token_type',
      serializers.serialize(object.tokenType,
          specifiedType: const FullType(String)),
      'refresh_token',
      serializers.serialize(object.refreshToken,
          specifiedType: const FullType(String)),
      'client_id',
      serializers.serialize(object.clientId,
          specifiedType: const FullType(String)),
      'client_secret',
      serializers.serialize(object.clientSecret,
          specifiedType: const FullType(String)),
      'origin',
      serializers.serialize(object.origin,
          specifiedType: const FullType(String)),
    ];
    if (object.scope != null) {
      result
        ..add('scope')
        ..add(serializers.serialize(object.scope,
            specifiedType: const FullType(String)));
    }

    return result;
  }

  @override
  Auth deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AuthBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'access_token':
          result.accessToken = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'expires_in':
          result.expiresIn = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'scope':
          result.scope = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'token_type':
          result.tokenType = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'refresh_token':
          result.refreshToken = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'client_id':
          result.clientId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'client_secret':
          result.clientSecret = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'origin':
          result.origin = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$Auth extends Auth {
  @override
  final String accessToken;
  @override
  final int expiresIn;
  @override
  final String scope;
  @override
  final String tokenType;
  @override
  final String refreshToken;
  @override
  final String clientId;
  @override
  final String clientSecret;
  @override
  final String origin;

  factory _$Auth([void updates(AuthBuilder b)]) =>
      (new AuthBuilder()..update(updates)).build();

  _$Auth._(
      {this.accessToken,
      this.expiresIn,
      this.scope,
      this.tokenType,
      this.refreshToken,
      this.clientId,
      this.clientSecret,
      this.origin})
      : super._() {
    if (accessToken == null) {
      throw new BuiltValueNullFieldError('Auth', 'accessToken');
    }
    if (expiresIn == null) {
      throw new BuiltValueNullFieldError('Auth', 'expiresIn');
    }
    if (tokenType == null) {
      throw new BuiltValueNullFieldError('Auth', 'tokenType');
    }
    if (refreshToken == null) {
      throw new BuiltValueNullFieldError('Auth', 'refreshToken');
    }
    if (clientId == null) {
      throw new BuiltValueNullFieldError('Auth', 'clientId');
    }
    if (clientSecret == null) {
      throw new BuiltValueNullFieldError('Auth', 'clientSecret');
    }
    if (origin == null) {
      throw new BuiltValueNullFieldError('Auth', 'origin');
    }
  }

  @override
  Auth rebuild(void updates(AuthBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  AuthBuilder toBuilder() => new AuthBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Auth &&
        accessToken == other.accessToken &&
        expiresIn == other.expiresIn &&
        scope == other.scope &&
        tokenType == other.tokenType &&
        refreshToken == other.refreshToken &&
        clientId == other.clientId &&
        clientSecret == other.clientSecret &&
        origin == other.origin;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc($jc(0, accessToken.hashCode),
                                expiresIn.hashCode),
                            scope.hashCode),
                        tokenType.hashCode),
                    refreshToken.hashCode),
                clientId.hashCode),
            clientSecret.hashCode),
        origin.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Auth')
          ..add('accessToken', accessToken)
          ..add('expiresIn', expiresIn)
          ..add('scope', scope)
          ..add('tokenType', tokenType)
          ..add('refreshToken', refreshToken)
          ..add('clientId', clientId)
          ..add('clientSecret', clientSecret)
          ..add('origin', origin))
        .toString();
  }
}

class AuthBuilder implements Builder<Auth, AuthBuilder> {
  _$Auth _$v;

  String _accessToken;
  String get accessToken => _$this._accessToken;
  set accessToken(String accessToken) => _$this._accessToken = accessToken;

  int _expiresIn;
  int get expiresIn => _$this._expiresIn;
  set expiresIn(int expiresIn) => _$this._expiresIn = expiresIn;

  String _scope;
  String get scope => _$this._scope;
  set scope(String scope) => _$this._scope = scope;

  String _tokenType;
  String get tokenType => _$this._tokenType;
  set tokenType(String tokenType) => _$this._tokenType = tokenType;

  String _refreshToken;
  String get refreshToken => _$this._refreshToken;
  set refreshToken(String refreshToken) => _$this._refreshToken = refreshToken;

  String _clientId;
  String get clientId => _$this._clientId;
  set clientId(String clientId) => _$this._clientId = clientId;

  String _clientSecret;
  String get clientSecret => _$this._clientSecret;
  set clientSecret(String clientSecret) => _$this._clientSecret = clientSecret;

  String _origin;
  String get origin => _$this._origin;
  set origin(String origin) => _$this._origin = origin;

  AuthBuilder();

  AuthBuilder get _$this {
    if (_$v != null) {
      _accessToken = _$v.accessToken;
      _expiresIn = _$v.expiresIn;
      _scope = _$v.scope;
      _tokenType = _$v.tokenType;
      _refreshToken = _$v.refreshToken;
      _clientId = _$v.clientId;
      _clientSecret = _$v.clientSecret;
      _origin = _$v.origin;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Auth other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Auth;
  }

  @override
  void update(void updates(AuthBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$Auth build() {
    final _$result = _$v ??
        new _$Auth._(
            accessToken: accessToken,
            expiresIn: expiresIn,
            scope: scope,
            tokenType: tokenType,
            refreshToken: refreshToken,
            clientId: clientId,
            clientSecret: clientSecret,
            origin: origin);
    replace(_$result);
    return _$result;
  }
}
