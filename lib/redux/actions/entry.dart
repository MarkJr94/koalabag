import 'package:koalabag/model/entry.dart';

class LoadEntries {}

class FetchEntries {}

class FetchEntriesOk {
  final List<Entry> entries;

  FetchEntriesOk(this.entries);
}

class LoadEntriesOk {
  final List<Entry> entries;

  LoadEntriesOk(this.entries);
}

class EntriesFail {
  final dynamic err;

  EntriesFail(this.err);
}
