import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';

import 'package:koalabag/serializers.dart';
import 'package:koalabag/model/tag.dart';

part 'entry_info.g.dart';

abstract class EntryInfo implements Built<EntryInfo, EntryInfoBuilder> {
  static Serializer<EntryInfo> get serializer => _$entryInfoSerializer;

  @BuiltValueField(wireName: 'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: 'domain_name')
  @nullable
  String get domainName;

  int get id;

  @BuiltValueField(wireName: 'is_archived')
  int get isArchived;

  @BuiltValueField(wireName: 'is_starred')
  int get isStarred;

  @nullable
  String get language;

  @nullable
  String get mimetype;

  @BuiltValueField(wireName: 'preview_picture')
  @nullable
  String get previewPicture;

  @BuiltValueField(wireName: 'reading_time')
  int get readingTime;

  BuiltList<Tag> get tags;

  String get title;

  @BuiltValueField(wireName: 'updated_at')
  DateTime get updatedAt;

  String get url;

  @BuiltValueField(wireName: 'user_email')
  String get userEmail;

  @BuiltValueField(wireName: 'user_id')
  int get userId;

  @BuiltValueField(wireName: 'user_name')
  String get userName;

  EntryInfo._();

  factory EntryInfo([updates(EntryInfoBuilder b)]) = _$EntryInfo;

  Map<String, dynamic> toMap() {
    return serializers.serializeWith(EntryInfo.serializer, this);
  }

  static EntryInfo fromMap(Map<String, dynamic> map) {
    return serializers.deserializeWith(EntryInfo.serializer, map);
  }

  bool starred() {
    return isStarred != 0;
  }

  bool archived() {
    return isArchived != 0;
  }
}
