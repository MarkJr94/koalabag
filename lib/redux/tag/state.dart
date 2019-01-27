import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:koalabag/model/tag.dart';

part 'state.g.dart';

abstract class TagState implements Built<TagState, TagStateBuilder> {
  static Serializer<TagState> get serializer => _$tagStateSerializer;

  bool get isSaving;

  BuiltList<Tag> get tags;

  TagState._();

  factory TagState([updates(TagStateBuilder b)]) = _$TagState;

  factory TagState.empty() {
    return _$TagState._(
      isSaving: false,
      tags: BuiltList(),
    );
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('TagState')
          ..add('isSaving', isSaving)
          ..add('tags', "<${tags.length} items>"))
        .toString();
  }
}
