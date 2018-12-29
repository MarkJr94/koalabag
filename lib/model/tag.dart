import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:koalabag/serializers.dart';

part 'tag.g.dart';

abstract class Tag implements Built<Tag, TagBuilder> {
  static Serializer<Tag> get serializer => _$tagSerializer;

  int get id;
  String get label;
  String get slug;

  Tag._();

  factory Tag([updates(TagBuilder b)]) = _$Tag;

  Map<String, dynamic> toMap() {
    return serializers.serializeWith(serializer, this);
  }

  static Tag fromMap(Map<String, dynamic> map) {
    return serializers.deserializeWith(serializer, map);
  }
}
