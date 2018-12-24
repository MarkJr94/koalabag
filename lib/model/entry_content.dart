import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:koalabag/serializers.dart';

part 'entry_content.g.dart';

abstract class EntryContent
    implements Built<EntryContent, EntryContentBuilder> {
  static Serializer<EntryContent> get serializer => _$entryContentSerializer;

  @nullable
  String get content;

  int get id;

  EntryContent._();

  factory EntryContent([updates(EntryContentBuilder b)]) = _$EntryContent;

  Map<String, dynamic> toMap() {
    return serializers.serializeWith(EntryContent.serializer, this);
  }

  static EntryContent fromMap(Map<String, dynamic> map) {
    return serializers.deserializeWith(EntryContent.serializer, map);
  }
}
