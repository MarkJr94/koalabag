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

  DateTime get created_at;

  @nullable
  String get domain_name;

  int get id;

  int get is_archived;

  int get is_starred;

  @nullable
  String get language;

  @nullable
  String get mimetype;

  @nullable
  String get preview_picture;

  int get reading_time;

  BuiltList<Tag> get tags;

  String get title;

  DateTime get updated_at;

  String get url;

  String get user_email;

  int get user_id;

  String get user_name;

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

  bool isStarred() {
    return is_starred != 0;
  }

  bool isArchived() {
    return is_archived != 0;
  }
}
