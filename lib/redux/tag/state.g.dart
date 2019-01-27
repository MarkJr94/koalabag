// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<TagState> _$tagStateSerializer = new _$TagStateSerializer();

class _$TagStateSerializer implements StructuredSerializer<TagState> {
  @override
  final Iterable<Type> types = const [TagState, _$TagState];
  @override
  final String wireName = 'TagState';

  @override
  Iterable serialize(Serializers serializers, TagState object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'isSaving',
      serializers.serialize(object.isSaving,
          specifiedType: const FullType(bool)),
      'tags',
      serializers.serialize(object.tags,
          specifiedType:
              const FullType(BuiltList, const [const FullType(Tag)])),
    ];

    return result;
  }

  @override
  TagState deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new TagStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'isSaving':
          result.isSaving = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'tags':
          result.tags.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(Tag)]))
              as BuiltList);
          break;
      }
    }

    return result.build();
  }
}

class _$TagState extends TagState {
  @override
  final bool isSaving;
  @override
  final BuiltList<Tag> tags;

  factory _$TagState([void updates(TagStateBuilder b)]) =>
      (new TagStateBuilder()..update(updates)).build();

  _$TagState._({this.isSaving, this.tags}) : super._() {
    if (isSaving == null) {
      throw new BuiltValueNullFieldError('TagState', 'isSaving');
    }
    if (tags == null) {
      throw new BuiltValueNullFieldError('TagState', 'tags');
    }
  }

  @override
  TagState rebuild(void updates(TagStateBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  TagStateBuilder toBuilder() => new TagStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TagState &&
        isSaving == other.isSaving &&
        tags == other.tags;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, isSaving.hashCode), tags.hashCode));
  }
}

class TagStateBuilder implements Builder<TagState, TagStateBuilder> {
  _$TagState _$v;

  bool _isSaving;
  bool get isSaving => _$this._isSaving;
  set isSaving(bool isSaving) => _$this._isSaving = isSaving;

  ListBuilder<Tag> _tags;
  ListBuilder<Tag> get tags => _$this._tags ??= new ListBuilder<Tag>();
  set tags(ListBuilder<Tag> tags) => _$this._tags = tags;

  TagStateBuilder();

  TagStateBuilder get _$this {
    if (_$v != null) {
      _isSaving = _$v.isSaving;
      _tags = _$v.tags?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TagState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$TagState;
  }

  @override
  void update(void updates(TagStateBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$TagState build() {
    _$TagState _$result;
    try {
      _$result =
          _$v ?? new _$TagState._(isSaving: isSaving, tags: tags.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'tags';
        tags.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'TagState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
