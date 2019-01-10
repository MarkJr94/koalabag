// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_to_entry.dart';

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

Serializer<TagToEntry> _$tagToEntrySerializer = new _$TagToEntrySerializer();

class _$TagToEntrySerializer implements StructuredSerializer<TagToEntry> {
  @override
  final Iterable<Type> types = const [TagToEntry, _$TagToEntry];
  @override
  final String wireName = 'TagToEntry';

  @override
  Iterable serialize(Serializers serializers, TagToEntry object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'entry_id',
      serializers.serialize(object.entryId, specifiedType: const FullType(int)),
      'tag_id',
      serializers.serialize(object.tagId, specifiedType: const FullType(int)),
    ];

    return result;
  }

  @override
  TagToEntry deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new TagToEntryBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'entry_id':
          result.entryId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'tag_id':
          result.tagId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$TagToEntry extends TagToEntry {
  @override
  final int entryId;
  @override
  final int tagId;

  factory _$TagToEntry([void updates(TagToEntryBuilder b)]) =>
      (new TagToEntryBuilder()..update(updates)).build();

  _$TagToEntry._({this.entryId, this.tagId}) : super._() {
    if (entryId == null) {
      throw new BuiltValueNullFieldError('TagToEntry', 'entryId');
    }
    if (tagId == null) {
      throw new BuiltValueNullFieldError('TagToEntry', 'tagId');
    }
  }

  @override
  TagToEntry rebuild(void updates(TagToEntryBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  TagToEntryBuilder toBuilder() => new TagToEntryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TagToEntry &&
        entryId == other.entryId &&
        tagId == other.tagId;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, entryId.hashCode), tagId.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('TagToEntry')
          ..add('entryId', entryId)
          ..add('tagId', tagId))
        .toString();
  }
}

class TagToEntryBuilder implements Builder<TagToEntry, TagToEntryBuilder> {
  _$TagToEntry _$v;

  int _entryId;
  int get entryId => _$this._entryId;
  set entryId(int entryId) => _$this._entryId = entryId;

  int _tagId;
  int get tagId => _$this._tagId;
  set tagId(int tagId) => _$this._tagId = tagId;

  TagToEntryBuilder();

  TagToEntryBuilder get _$this {
    if (_$v != null) {
      _entryId = _$v.entryId;
      _tagId = _$v.tagId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TagToEntry other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$TagToEntry;
  }

  @override
  void update(void updates(TagToEntryBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$TagToEntry build() {
    final _$result = _$v ?? new _$TagToEntry._(entryId: entryId, tagId: tagId);
    replace(_$result);
    return _$result;
  }
}
