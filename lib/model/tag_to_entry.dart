import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:koalabag/serializers.dart';

part 'tag_to_entry.g.dart';

abstract class TagToEntry implements Built<TagToEntry, TagToEntryBuilder> {
  static Serializer<TagToEntry> get serializer => _$tagToEntrySerializer;

  @BuiltValueField(wireName: 'entry_id')
  int get entryId;
  @BuiltValueField(wireName: 'tag_id')
  int get tagId;

  TagToEntry._();

  factory TagToEntry([updates(TagToEntryBuilder b)]) = _$TagToEntry;

  Map<String, dynamic> toMap() {
    return serializers.serializeWith(serializer, this);
  }

  static TagToEntry fromMap(Map<String, dynamic> map) {
    return serializers.deserializeWith(serializer, map);
  }
}
