// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AuthState _$fetching = const AuthState._('fetching');
const AuthState _$good = const AuthState._('good');
const AuthState _$bad = const AuthState._('bad');

AuthState _$valueOf(String name) {
  switch (name) {
    case 'fetching':
      return _$fetching;
    case 'good':
      return _$good;
    case 'bad':
      return _$bad;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<AuthState> _$values = new BuiltSet<AuthState>(const <AuthState>[
  _$fetching,
  _$good,
  _$bad,
]);

Serializer<AuthState> _$authStateSerializer = new _$AuthStateSerializer();
Serializer<AppState> _$appStateSerializer = new _$AppStateSerializer();

class _$AuthStateSerializer implements PrimitiveSerializer<AuthState> {
  @override
  final Iterable<Type> types = const <Type>[AuthState];
  @override
  final String wireName = 'AuthState';

  @override
  Object serialize(Serializers serializers, AuthState object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  AuthState deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AuthState.valueOf(serialized as String);
}

class _$AppStateSerializer implements StructuredSerializer<AppState> {
  @override
  final Iterable<Type> types = const [AppState, _$AppState];
  @override
  final String wireName = 'AppState';

  @override
  Iterable serialize(Serializers serializers, AppState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'isAuthorizing',
      serializers.serialize(object.isAuthorizing,
          specifiedType: const FullType(bool)),
      'authState',
      serializers.serialize(object.authState,
          specifiedType: const FullType(AuthState)),
    ];
    if (object.auth != null) {
      result
        ..add('auth')
        ..add(serializers.serialize(object.auth,
            specifiedType: const FullType(Auth)));
    }
    if (object.entry != null) {
      result
        ..add('entry')
        ..add(serializers.serialize(object.entry,
            specifiedType: const FullType(EntryState)));
    }

    return result;
  }

  @override
  AppState deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AppStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'auth':
          result.auth.replace(serializers.deserialize(value,
              specifiedType: const FullType(Auth)) as Auth);
          break;
        case 'isAuthorizing':
          result.isAuthorizing = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'authState':
          result.authState = serializers.deserialize(value,
              specifiedType: const FullType(AuthState)) as AuthState;
          break;
        case 'entry':
          result.entry.replace(serializers.deserialize(value,
              specifiedType: const FullType(EntryState)) as EntryState);
          break;
      }
    }

    return result.build();
  }
}

class _$AppState extends AppState {
  @override
  final Auth auth;
  @override
  final bool isAuthorizing;
  @override
  final AuthState authState;
  @override
  final EntryState entry;

  factory _$AppState([void updates(AppStateBuilder b)]) =>
      (new AppStateBuilder()..update(updates)).build();

  _$AppState._({this.auth, this.isAuthorizing, this.authState, this.entry})
      : super._() {
    if (isAuthorizing == null) {
      throw new BuiltValueNullFieldError('AppState', 'isAuthorizing');
    }
    if (authState == null) {
      throw new BuiltValueNullFieldError('AppState', 'authState');
    }
  }

  @override
  AppState rebuild(void updates(AppStateBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  AppStateBuilder toBuilder() => new AppStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AppState &&
        auth == other.auth &&
        isAuthorizing == other.isAuthorizing &&
        authState == other.authState &&
        entry == other.entry;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, auth.hashCode), isAuthorizing.hashCode),
            authState.hashCode),
        entry.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('AppState')
          ..add('auth', auth)
          ..add('isAuthorizing', isAuthorizing)
          ..add('authState', authState)
          ..add('entry', entry))
        .toString();
  }
}

class AppStateBuilder implements Builder<AppState, AppStateBuilder> {
  _$AppState _$v;

  AuthBuilder _auth;
  AuthBuilder get auth => _$this._auth ??= new AuthBuilder();
  set auth(AuthBuilder auth) => _$this._auth = auth;

  bool _isAuthorizing;
  bool get isAuthorizing => _$this._isAuthorizing;
  set isAuthorizing(bool isAuthorizing) =>
      _$this._isAuthorizing = isAuthorizing;

  AuthState _authState;
  AuthState get authState => _$this._authState;
  set authState(AuthState authState) => _$this._authState = authState;

  EntryStateBuilder _entry;
  EntryStateBuilder get entry => _$this._entry ??= new EntryStateBuilder();
  set entry(EntryStateBuilder entry) => _$this._entry = entry;

  AppStateBuilder();

  AppStateBuilder get _$this {
    if (_$v != null) {
      _auth = _$v.auth?.toBuilder();
      _isAuthorizing = _$v.isAuthorizing;
      _authState = _$v.authState;
      _entry = _$v.entry?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AppState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$AppState;
  }

  @override
  void update(void updates(AppStateBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$AppState build() {
    _$AppState _$result;
    try {
      _$result = _$v ??
          new _$AppState._(
              auth: _auth?.build(),
              isAuthorizing: isAuthorizing,
              authState: authState,
              entry: _entry?.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'auth';
        _auth?.build();

        _$failedField = 'entry';
        _entry?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'AppState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
