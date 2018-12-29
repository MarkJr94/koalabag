// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

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

Serializer<EntryState> _$entryStateSerializer = new _$EntryStateSerializer();

class _$EntryStateSerializer implements StructuredSerializer<EntryState> {
  @override
  final Iterable<Type> types = const [EntryState, _$EntryState];
  @override
  final String wireName = 'EntryState';

  @override
  Iterable serialize(Serializers serializers, EntryState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'isLoading',
      serializers.serialize(object.isLoading,
          specifiedType: const FullType(bool)),
      'isFetching',
      serializers.serialize(object.isFetching,
          specifiedType: const FullType(bool)),
      'textScaleFactor',
      serializers.serialize(object.textScaleFactor,
          specifiedType: const FullType(double)),
      'entries',
      serializers.serialize(object.entries,
          specifiedType:
              const FullType(BuiltList, const [const FullType(EntryInfo)])),
    ];

    return result;
  }

  @override
  EntryState deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new EntryStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'isLoading':
          result.isLoading = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'isFetching':
          result.isFetching = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'textScaleFactor':
          result.textScaleFactor = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'entries':
          result.entries.replace(serializers.deserialize(value,
              specifiedType: const FullType(
                  BuiltList, const [const FullType(EntryInfo)])) as BuiltList);
          break;
      }
    }

    return result.build();
  }
}

class _$EntryState extends EntryState {
  @override
  final bool isLoading;
  @override
  final bool isFetching;
  @override
  final double textScaleFactor;
  @override
  final BuiltList<EntryInfo> entries;

  factory _$EntryState([void updates(EntryStateBuilder b)]) =>
      (new EntryStateBuilder()..update(updates)).build();

  _$EntryState._(
      {this.isLoading, this.isFetching, this.textScaleFactor, this.entries})
      : super._() {
    if (isLoading == null) {
      throw new BuiltValueNullFieldError('EntryState', 'isLoading');
    }
    if (isFetching == null) {
      throw new BuiltValueNullFieldError('EntryState', 'isFetching');
    }
    if (textScaleFactor == null) {
      throw new BuiltValueNullFieldError('EntryState', 'textScaleFactor');
    }
    if (entries == null) {
      throw new BuiltValueNullFieldError('EntryState', 'entries');
    }
  }

  @override
  EntryState rebuild(void updates(EntryStateBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  EntryStateBuilder toBuilder() => new EntryStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EntryState &&
        isLoading == other.isLoading &&
        isFetching == other.isFetching &&
        textScaleFactor == other.textScaleFactor &&
        entries == other.entries;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, isLoading.hashCode), isFetching.hashCode),
            textScaleFactor.hashCode),
        entries.hashCode));
  }
}

class EntryStateBuilder implements Builder<EntryState, EntryStateBuilder> {
  _$EntryState _$v;

  bool _isLoading;
  bool get isLoading => _$this._isLoading;
  set isLoading(bool isLoading) => _$this._isLoading = isLoading;

  bool _isFetching;
  bool get isFetching => _$this._isFetching;
  set isFetching(bool isFetching) => _$this._isFetching = isFetching;

  double _textScaleFactor;
  double get textScaleFactor => _$this._textScaleFactor;
  set textScaleFactor(double textScaleFactor) =>
      _$this._textScaleFactor = textScaleFactor;

  ListBuilder<EntryInfo> _entries;
  ListBuilder<EntryInfo> get entries =>
      _$this._entries ??= new ListBuilder<EntryInfo>();
  set entries(ListBuilder<EntryInfo> entries) => _$this._entries = entries;

  EntryStateBuilder();

  EntryStateBuilder get _$this {
    if (_$v != null) {
      _isLoading = _$v.isLoading;
      _isFetching = _$v.isFetching;
      _textScaleFactor = _$v.textScaleFactor;
      _entries = _$v.entries?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EntryState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$EntryState;
  }

  @override
  void update(void updates(EntryStateBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$EntryState build() {
    _$EntryState _$result;
    try {
      _$result = _$v ??
          new _$EntryState._(
              isLoading: isLoading,
              isFetching: isFetching,
              textScaleFactor: textScaleFactor,
              entries: entries.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'entries';
        entries.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'EntryState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}
