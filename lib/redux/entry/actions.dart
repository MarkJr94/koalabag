import 'dart:async';

import 'package:koalabag/model/entry.dart';
import 'package:built_collection/built_collection.dart';
import 'package:meta/meta.dart';

class LoadEntries {}

class FetchEntries {
  final Completer<Null> completer;

  FetchEntries(this.completer);
}

class UpdateEntries {
  final BuiltList<Entry> entries;

  UpdateEntries(this.entries);
}

class LoadEntriesOk {
  final BuiltList<Entry> entries;

  LoadEntriesOk(this.entries);
}

class EntriesFail {
  final dynamic err;

  EntriesFail(this.err);
}

class ChangeEntry {
  bool starred;
  bool archived;
  final Entry entry;

  ChangeEntry({@required this.starred, this.archived, this.entry});
}

class ChangeEntryOk {
  final Entry entry;

  ChangeEntryOk(this.entry);
}

class UpdateEntry {
  final Entry entry;

  UpdateEntry({@required this.entry});
}

class UpdateEntryOk {
  final Entry entry;

  UpdateEntryOk(this.entry);
}

class AddEntry {
  final Uri uri;

  AddEntry({@required this.uri});
}

class AddEntryOk {
  final Entry entry;

  AddEntryOk(this.entry);
}

class EntryFail {
  final dynamic err;

  EntryFail(this.err);
}
