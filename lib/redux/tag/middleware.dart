import 'package:redux/redux.dart';

import 'package:koalabag/data/repository.dart';
import 'package:koalabag/redux/app/state.dart';
import 'package:koalabag/redux/tag.dart';

List<Middleware<AppState>> createTagMiddleware(ITagDao dao) {
  final load = _load(dao);
  final fail = _fail(dao);

  final add = _add(dao);
  final remove = _remove(dao);
  final delete = _delete(dao);

  return [
    TypedMiddleware<AppState, LoadTags>(load),
    TypedMiddleware<AppState, TagFail>(fail),
    TypedMiddleware<AppState, AddTag>(add),
    TypedMiddleware<AppState, RemoveTag>(remove),
    TypedMiddleware<AppState, DeleteTag>(delete),
  ];
}

Middleware<AppState> _load(ITagDao dao) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) async {
    try {
      var entries = await dao.getAll();
      store.dispatch(LoadTagsOk(entries));
    } catch (err) {
      store.dispatch(TagFail(err));
    }

    next(action);
  };
}

Middleware<AppState> _fail(ITagDao dao) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) {
    assert(action is TagFail);
    final TagFail _act = action;
    print("TagFail: ${_act.err}");

    next(action);
  };
}

Middleware<AppState> _add(ITagDao dao) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) async {
    try {
      assert(action is AddTag);
      final AddTag act = action;
      await dao.add(act.entryId, act.tag);
      final newTag = await dao.byLabel(act.tag);
      store.dispatch(AddTagOk(newTag));
    } catch (err) {
      store.dispatch(TagFail(err));
    }

    next(action);
  };
}

Middleware<AppState> _remove(ITagDao dao) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) async {
    try {
      assert(action is RemoveTag);
      final RemoveTag act = action;
      await dao.remove(act.entryId, act.tag);
      store.dispatch(RemoveTagOk(act.tag));
    } catch (err) {
      store.dispatch(TagFail(err));
    }

    next(action);
  };
}

// TODO: implement
Middleware<AppState> _delete(ITagDao dao) {
  return (Store<AppState> store, dynamic action, NextDispatcher next) async {
    print('tag _delete middleware unimplemented');

    next(action);
  };
}
