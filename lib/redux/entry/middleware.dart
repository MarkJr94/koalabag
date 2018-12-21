import 'package:koalabag/data/repository.dart';
import 'package:koalabag/redux/entry.dart';
import 'package:koalabag/redux/app/state.dart';

import 'package:redux/redux.dart';

List<Middleware<AppState>> createEntryMiddle(EntryDao dao) {
  final load = _load(dao);
  final fail = _entryFail(dao);
  final changeOne = _changeOne(dao);
  final updateOne = _updateOne(dao);
  final addOne = _addOne(dao);
  final sync = _sync(dao);

  return [
    TypedMiddleware<AppState, EntrySync>(sync),
    TypedMiddleware<AppState, LoadEntries>(load),
    TypedMiddleware<AppState, EntryFail>(fail),
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

Middleware<AppState> _sync(EntryDao dao) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) async {
    assert(action is EntrySync);
    final EntrySync _act = action;

    try {
      await dao.sync(store.state.auth);
      store.dispatch(LoadEntries());
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

Middleware<AppState> _entryFail(EntryDao dao) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    assert(action is EntryFail);
    final EntryFail _act = action;
    print("EntriesFail: ${_act.err}");

    next(action);
  };
}
