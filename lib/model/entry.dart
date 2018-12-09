import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';

import 'package:koalabag/serializers.dart';

part 'entry.g.dart';

abstract class Tag implements Built<Tag, TagBuilder> {
  static Serializer<Tag> get serializer => _$tagSerializer;

  int get id;
  String get label;
  String get slug;

  Tag._();

  factory Tag([updates(TagBuilder b)]) = _$Tag;
}

abstract class Entry implements Built<Entry, EntryBuilder> {
  static Serializer<Entry> get serializer => _$entrySerializer;

  @nullable
  String get content;

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

  Entry._();

  factory Entry([updates(EntryBuilder b)]) = _$Entry;

  static Entry fromJson(Map<String, dynamic> map) {
    return serializers.deserializeWith(Entry.serializer, map);
  }

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(serializer, this);
  }

  Map<String, dynamic> toMap() {
    return serializers.serializeWith(serializer, this);
  }

  static Entry fromMap(Map<String, dynamic> map) {
    return serializers.deserializeWith(Entry.serializer, map);
  }

  bool starred() {
    return isStarred != 0;
  }

  bool archived() {
    return isArchived != 0;
  }
}
