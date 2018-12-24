import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';

import 'package:koalabag/serializers.dart';
import 'package:koalabag/model/entry_content.dart';
import 'package:koalabag/model/entry_info.dart';
import 'package:koalabag/model/tag.dart';

part 'entry.g.dart';

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

  factory Entry.fromJson(Map<String, dynamic> map) {
    return serializers.deserializeWith(Entry.serializer, map);
  }

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(serializer, this);
  }

  Map<String, dynamic> toMap() {
    return serializers.serializeWith(serializer, this);
  }

  factory Entry.fromMap(Map<String, dynamic> map) {
    return serializers.deserializeWith(Entry.serializer, map);
  }

  factory Entry.unSplit(EntryInfo ei, EntryContent ec) {
    return Entry((b) => b
      ..content = ec.content
      ..createdAt = ei.createdAt
      ..domainName = ei.domainName
      ..id = ei.id
      ..isArchived = ei.isArchived
      ..isStarred = ei.isStarred
      ..language = ei.language
      ..mimetype = ei.mimetype
      ..previewPicture = ei.previewPicture
      ..readingTime = ei.readingTime
      ..tags.replace(ei.tags)
      ..title = ei.title
      ..updatedAt = ei.updatedAt
      ..url = ei.url
      ..userEmail = ei.userEmail
      ..userId = ei.userId
      ..userName = ei.userName);
  }

  bool starred() {
    return isStarred != 0;
  }

  bool archived() {
    return isArchived != 0;
  }

  EntryInfo toInfo() {
    return EntryInfo((b) => b
      ..createdAt = createdAt
      ..domainName = domainName
      ..id = id
      ..isArchived = isArchived
      ..isStarred = isStarred
      ..language = language
      ..mimetype = mimetype
      ..previewPicture = previewPicture
      ..readingTime = readingTime
      ..tags.replace(tags)
      ..title = title
      ..updatedAt = updatedAt
      ..url = url
      ..userEmail = userEmail
      ..userId = userId
      ..userName = userName);
  }

  EntryContent toContent() {
    return EntryContent((b) => b
      ..id = id
      ..content = content);
  }
}
