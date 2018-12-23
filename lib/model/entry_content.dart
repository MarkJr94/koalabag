import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'entry_content.g.dart';

abstract class EntryContent
    implements Built<EntryContent, EntryContentBuilder> {
  static Serializer<EntryContent> get serializer => _$entryContentSerializer;

  @nullable
  String get content;

  int get id;

  factory EntryContent([updates(EntryContentBuilder b)]) = _$EntryContent;

  EntryContent._();
}
