import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:koalabag/model/entry_info.dart';

part 'state.g.dart';

abstract class EntryState implements Built<EntryState, EntryStateBuilder> {
  static Serializer<EntryState> get serializer => _$entryStateSerializer;

  bool get isLoading;

  bool get isFetching;

  double get textScaleFactor;

  BuiltList<EntryInfo> get entries;

  EntryState._();

  factory EntryState([updates(EntryStateBuilder b)]) = _$EntryState;

  factory EntryState.empty() {
    return _$EntryState._(
        isFetching: false,
        isLoading: false,
        textScaleFactor: 1.0,
        entries: BuiltList());
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('EntryState')
          ..add('isLoading', isLoading)
          ..add('isFetching', isFetching)
          ..add('textScaleFactor', textScaleFactor)
          ..add('entries', "<${entries.length} items>"))
        .toString();
  }
}
