import 'package:redux/redux.dart';

import 'package:koalabag/redux/entry.dart';

Reducer<EntryState> entryReducer = combineReducers([
  TypedReducer<EntryState, LoadEntries>(_onLoad),
  TypedReducer<EntryState, LoadEntriesOk>(_onLoadOk),
  TypedReducer<EntryState, ChangeEntry>(_onChange),
  TypedReducer<EntryState, ChangeEntryOk>(_onChangeOk),
  TypedReducer<EntryState, AddEntry>(_onAdd),
  TypedReducer<EntryState, AddEntryOk>(_onAddOk),
  TypedReducer<EntryState, EntrySync>(_onSync),
  TypedReducer<EntryState, EntrySyncOk>(_onSyncOk),
  TypedReducer<EntryState, EntryFail>(_onFail),
  TypedReducer<EntryState, GrowText>(_onGrow),
  TypedReducer<EntryState, ShrinkText>(_onShrink),
]);

EntryState _onLoad(EntryState entry, LoadEntries act) {
  return entry.rebuild((b) => b..isLoading = true);
}

EntryState _onLoadOk(EntryState entry, LoadEntriesOk act) {
  return entry.rebuild((b) => b
    ..isLoading = false
    ..entries.replace(act.entries));
}

EntryState _onChange(EntryState entry, ChangeEntry act) {
  return entry.rebuild((b) => b..isLoading = true);
}

EntryState _onChangeOk(EntryState entryS, ChangeEntryOk action) {
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

EntryState _onAdd(EntryState entryS, AddEntry action) {
  return entryS.rebuild((b) => b
    ..isLoading = true
    ..isFetching = true);
}

EntryState _onAddOk(EntryState entryS, AddEntryOk action) {
  return entryS.rebuild((b) => b
    ..isFetching = false
    ..isLoading = false
    ..entries.insert(0, action.entry));
}

const _scaleIncr = .2;

EntryState _onGrow(EntryState entryS, GrowText action) {
  return entryS
      .rebuild((b) => b..textScaleFactor = b.textScaleFactor + _scaleIncr);
}

EntryState _onShrink(EntryState entryS, ShrinkText action) {
  return entryS
      .rebuild((b) => b..textScaleFactor = b.textScaleFactor - _scaleIncr);
}
