// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry_content.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<EntryContent> _$entryContentSerializer =
    new _$EntryContentSerializer();

class _$EntryContentSerializer implements StructuredSerializer<EntryContent> {
  @override
  final Iterable<Type> types = const [EntryContent, _$EntryContent];
  @override
  final String wireName = 'EntryContent';

  @override
  Iterable serialize(Serializers serializers, EntryContent object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
    ];
    if (object.content != null) {
      result
        ..add('content')
        ..add(serializers.serialize(object.content,
            specifiedType: const FullType(String)));
    }

    return result;
  }

  @override
  EntryContent deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new EntryContentBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'content':
          result.content = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
      }
    }

    return result.build();
  }
}

class _$EntryContent extends EntryContent {
  @override
  final String content;
  @override
  final int id;

  factory _$EntryContent([void updates(EntryContentBuilder b)]) =>
      (new EntryContentBuilder()..update(updates)).build();

  _$EntryContent._({this.content, this.id}) : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('EntryContent', 'id');
    }
  }

  @override
  EntryContent rebuild(void updates(EntryContentBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  EntryContentBuilder toBuilder() => new EntryContentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EntryContent && content == other.content && id == other.id;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, content.hashCode), id.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('EntryContent')
          ..add('content', content)
          ..add('id', id))
        .toString();
  }
}

class EntryContentBuilder
    implements Builder<EntryContent, EntryContentBuilder> {
  _$EntryContent _$v;

  String _content;
  String get content => _$this._content;
  set content(String content) => _$this._content = content;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  EntryContentBuilder();

  EntryContentBuilder get _$this {
    if (_$v != null) {
      _content = _$v.content;
      _id = _$v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EntryContent other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$EntryContent;
  }

  @override
  void update(void updates(EntryContentBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$EntryContent build() {
    final _$result = _$v ?? new _$EntryContent._(content: content, id: id);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
