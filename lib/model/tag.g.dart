// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag.dart';

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

Serializer<Tag> _$tagSerializer = new _$TagSerializer();

class _$TagSerializer implements StructuredSerializer<Tag> {
  @override
  final Iterable<Type> types = const [Tag, _$Tag];
  @override
  final String wireName = 'Tag';

  @override
  Iterable serialize(Serializers serializers, Tag object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(int)),
      'label',
      serializers.serialize(object.label,
          specifiedType: const FullType(String)),
      'slug',
      serializers.serialize(object.slug, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  Tag deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new TagBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'label':
          result.label = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'slug':
          result.slug = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$Tag extends Tag {
  @override
  final int id;
  @override
  final String label;
  @override
  final String slug;

  factory _$Tag([void updates(TagBuilder b)]) =>
      (new TagBuilder()..update(updates)).build();

  _$Tag._({this.id, this.label, this.slug}) : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('Tag', 'id');
    }
    if (label == null) {
      throw new BuiltValueNullFieldError('Tag', 'label');
    }
    if (slug == null) {
      throw new BuiltValueNullFieldError('Tag', 'slug');
    }
  }

  @override
  Tag rebuild(void updates(TagBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  TagBuilder toBuilder() => new TagBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Tag &&
        id == other.id &&
        label == other.label &&
        slug == other.slug;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc(0, id.hashCode), label.hashCode), slug.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Tag')
          ..add('id', id)
          ..add('label', label)
          ..add('slug', slug))
        .toString();
  }
}

class TagBuilder implements Builder<Tag, TagBuilder> {
  _$Tag _$v;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  String _label;
  String get label => _$this._label;
  set label(String label) => _$this._label = label;

  String _slug;
  String get slug => _$this._slug;
  set slug(String slug) => _$this._slug = slug;

  TagBuilder();

  TagBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _label = _$v.label;
      _slug = _$v.slug;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Tag other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Tag;
  }

  @override
  void update(void updates(TagBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$Tag build() {
    final _$result = _$v ?? new _$Tag._(id: id, label: label, slug: slug);
    replace(_$result);
    return _$result;
  }
}
