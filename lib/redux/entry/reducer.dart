import 'package:redux/redux.dart';

import 'package:koalabag/redux/entry.dart';

Reducer<EntryState> entryReducer = combineReducers([
  TypedReducer<EntryState, LoadEntriesOk>(_onLoaded),
  TypedReducer<EntryState, LoadEntries>(_onLoad),
  TypedReducer<EntryState, FetchEntries>(_onFetch),
  TypedReducer<EntryState, EntriesFail>(_onFail),
  TypedReducer<EntryState, UpdateEntryOk>(_onUpdate),
  TypedReducer<EntryState, AddEntryOk>(_onAdd),
]);

EntryState _onLoaded(EntryState entry, LoadEntriesOk act) {
  return entry.rebuild((b) => b
    ..isLoading = false
    ..isFetching = false
    ..entries.replace(act.entries));
}

EntryState _onLoad(EntryState entry, LoadEntries act) {
  return entry.rebuild((b) => b..isLoading = true);
}

EntryState _onFetch(EntryState entry, FetchEntries act) {
  return entry.rebuild((b) => b..isFetching = true);
}

EntryState _onFail(EntryState entry, EntriesFail act) {
  return entry.rebuild((b) => b
    ..isFetching = false
    ..isLoading = false);
}

EntryState _onUpdate(EntryState entryS, UpdateEntryOk action) {
  // Check if list contains entry
  final idx = entryS.entries.indexWhere((e) => e.id == action.entry.id);

  if (idx >= 0) {
    return entryS.rebuild((b) => b..entries[idx] = action.entry);
  }

  return entryS;
}

EntryState _onAdd(EntryState entryS, AddEntryOk action) {
  return entryS.rebuild((b) => b..entries.insert(0, action.entry));
}
