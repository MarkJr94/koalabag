import 'package:redux/redux.dart';

import 'package:koalabag/redux/entry.dart';

Reducer<EntryState> entryReducer = combineReducers([
  TypedReducer<EntryState, LoadEntries>(_onLoad),
  TypedReducer<EntryState, LoadEntriesOk>(_onLoadOk),
  TypedReducer<EntryState, UpdateEntry>(_onUpdate),
  TypedReducer<EntryState, UpdateEntryOk>(_onUpdateOk),
  TypedReducer<EntryState, AddEntryOk>(_onAdd),
  TypedReducer<EntryState, EntrySync>(_onSync),
  TypedReducer<EntryState, EntrySyncOk>(_onSyncOk),
  TypedReducer<EntryState, EntryFail>(_onFail),
]);

EntryState _onLoad(EntryState entry, LoadEntries act) {
  return entry.rebuild((b) => b..isLoading = true);
}

EntryState _onLoadOk(EntryState entry, LoadEntriesOk act) {
  return entry.rebuild((b) => b
    ..isLoading = false
    ..entries.replace(act.entries));
}

EntryState _onUpdate(EntryState entry, UpdateEntry act) {
  return entry.rebuild((b) => b..isLoading = true);
}

EntryState _onUpdateOk(EntryState entryS, UpdateEntryOk action) {
  // Check if list contains entry
  final idx = entryS.entries.indexWhere((e) => e.id == action.entry.id);

  if (idx >= 0) {
    return entryS.rebuild((b) => b
      ..entries[idx] = action.entry
      ..isFetching = false);
  }

  return entryS.rebuild((b) => b..isFetching = false);
}

EntryState _onFail(EntryState entry, EntryFail act) {
  return entry.rebuild((b) => b
    ..isFetching = false
    ..isLoading = false);
}

EntryState _onSync(EntryState entry, EntrySync act) {
  return entry.rebuild((b) => b
    ..isFetching = true
    ..isLoading = true);
}

EntryState _onSyncOk(EntryState entry, EntrySyncOk act) {
  return entry.rebuild((b) => b
    ..isFetching = false
    ..isLoading = false);
}

EntryState _onAdd(EntryState entryS, AddEntryOk action) {
  return entryS.rebuild((b) => b..entries.insert(0, action.entry));
}
