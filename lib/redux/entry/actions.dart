import 'dart:async';

import 'package:koalabag/model/entry_info.dart';
import 'package:built_collection/built_collection.dart';
import 'package:meta/meta.dart';

class EntryReq {}

class EntryFail {
  final dynamic err;

  EntryFail(this.err);
}

class EntrySync extends EntryReq {
  final Completer<Null> completer;

  EntrySync(this.completer);
}

class EntrySyncOk {}

class LoadEntries extends EntryReq {}

class LoadEntriesOk {
  final BuiltList<EntryInfo> entries;

  LoadEntriesOk(this.entries);
}

class EntriesFail extends EntryFail {
  EntriesFail(dynamic err) : super(err);
}

class ChangeEntry extends EntryReq {
  bool starred;
  bool archived;
  final EntryInfo entry;

  ChangeEntry({@required this.starred, @required this.archived, this.entry});
}

class ChangeEntryOk {
  final EntryInfo entry;

  ChangeEntryOk(this.entry);
}

class GrowText {}

class ShrinkText {}

class AddEntry extends EntryReq {
  final Uri uri;

  AddEntry({@required this.uri});
}

class AddEntryOk {
  final EntryInfo entry;

  AddEntryOk(this.entry);
}
