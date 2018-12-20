import 'package:built_collection/built_collection.dart';

import 'package:koalabag/data/repository.dart';
import 'package:koalabag/model.dart';
import 'package:koalabag/redux/entry.dart';
import 'package:koalabag/redux/app/state.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createEntryMiddle(EntryDao dao) {
  final load = _load(dao);
  final fetch = _fetch(dao);
  final fail = _entryFail(dao);
  final update = _updateEntries(dao);
  final changeOne = _changeOne(dao);
  final updateOne = _updateOne(dao);
  final addOne = _addOne(dao);

  return [
    TypedMiddleware<AppState, LoadEntries>(load),
    TypedMiddleware<AppState, FetchEntries>(fetch),
    TypedMiddleware<AppState, EntryFail>(fail),
    TypedMiddleware<AppState, UpdateEntries>(update),
    TypedMiddleware<AppState, ChangeEntry>(changeOne),
    TypedMiddleware<AppState, UpdateEntry>(updateOne),
    TypedMiddleware<AppState, AddEntry>(addOne),
  ];
}

Middleware<AppState> _load(EntryDao dao) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) async {
    try {
      var entries = await dao.loadEntries();
      store.dispatch(LoadEntriesOk(entries));
    } catch (err) {
      store.dispatch(EntriesFail(err));
    }

    next(action);
  };
}

Middleware<AppState> _fetch(EntryDao dao) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) async {
    assert(action is FetchEntries);
    final FetchEntries _act = action;

    try {
      var entries = await dao.fetchEntries(store.state.auth).fold(
          BuiltList<Entry>(), (BuiltList<Entry> acc, BuiltList<Entry> batch) {
        print("Got a batch of ${batch.length} entries");
        return acc.rebuild((b) => b..addAll(batch));
      });
      store.dispatch(UpdateEntries(entries));
      _act.completer.complete();
    } catch (err) {
      store.dispatch(EntriesFail(err));
      _act.completer.complete();
    }

    next(action);
  };
}

Middleware<AppState> _changeOne(EntryDao dao) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) async {
    assert(action is ChangeEntry);
    final ChangeEntry _act = action;

    try {
      final changedEntry = await dao.changeEntry(store.state.auth, _act.entry,
          starred: _act.starred, archived: _act.archived);

      store.dispatch(ChangeEntryOk(changedEntry));
      store.dispatch(UpdateEntry(entry: changedEntry));
    } catch (err, bt) {
      print("ChangeEntry error: $err");
      print("ChangeEntry backtrace: $bt");
      store.dispatch(EntryFail(err));
    }

    next(action);
  };
}

Middleware<AppState> _addOne(EntryDao dao) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) async {
    assert(action is AddEntry);
    final AddEntry _act = action;

    try {
      final newEntry = await dao.add(
        store.state.auth,
        _act.uri,
      );

      print("AddEntry Got one $newEntry");

      store.dispatch(AddEntryOk(newEntry));
      store.dispatch(UpdateEntry(entry: newEntry));
    } catch (err, bt) {
      print("AddEntry error: $err");
      print("AddEntry backtrace: $bt");
      store.dispatch(EntryFail(err));
    }

    next(action);
  };
}

Middleware<AppState> _updateOne(EntryDao dao) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) async {
    assert(action is UpdateEntry);
    final UpdateEntry _act = action;

    try {
      final changedEntry = await dao.updateEntry(_act.entry);

      store.dispatch(UpdateEntryOk(changedEntry));
    } catch (err) {
      print("UpdateEntry error: $err");
      store.dispatch(EntryFail(err));
    }

    next(action);
  };
}

Middleware<AppState> _updateEntries(EntryDao dao) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) async {
    assert(action is UpdateEntries);
    final UpdateEntries _act = action;
    try {
      await dao.mergeSaveEntries(_act.entries);
      store.dispatch(LoadEntries());
    } catch (err) {
      store.dispatch(EntriesFail(err));
    }

    next(action);
  };
}

Middleware<AppState> _entryFail(EntryDao dao) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    assert(action is EntryFail);
    final EntryFail _act = action;
    print("EntriesFail: ${_act.err}");

    next(action);
  };
}

// TODO WORK ON SYNCING
