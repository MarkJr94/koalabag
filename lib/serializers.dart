import 'package:built_value/standard_json_plugin.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';

import 'package:koalabag/model.dart';

part 'serializers.g.dart';

@SerializersFor(const [
  Auth,
  Entry,
  EntryContent,
  EntryInfo,
  Tag,
  TagToEntry,
])
final Serializers serializers = (_$serializers.toBuilder()
      ..addPlugin(StandardJsonPlugin())
      ..add(Iso8601DateTimeSerializer()))
    .build();
