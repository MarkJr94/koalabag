import 'package:redux/redux.dart';

import 'package:koalabag/redux/tag.dart';

Reducer<TagState> tagReducer = combineReducers([
  TypedReducer<TagState, TagReq>(_onReq),
  TypedReducer<TagState, TagReqOk>(_onOk),
  TypedReducer<TagState, TagFail>(_onFail),
  TypedReducer<TagState, LoadTagsOk>(_onLoad),
  TypedReducer<TagState, AddTagOk>(_onAdd),
  TypedReducer<TagState, RemoveTagOk>(_onRemove),
  TypedReducer<TagState, DeleteTagOk>(_onDelete),
]);

TagState _onReq(TagState state, TagReq act) =>
    state.rebuild((b) => b..isSaving = true);

TagState _onOk(TagState state, TagReqOk act) =>
    state.rebuild((b) => b..isSaving = false);

TagState _onFail(TagState state, TagFail act) =>
    state.rebuild((b) => b..isSaving = false);

TagState _onLoad(TagState state, LoadTagsOk act) {
  print('_onLoad: act.tags = ${act.tags}');
  return state.rebuild((b) => b..tags.replace(act.tags));
}

TagState _onAdd(TagState state, AddTagOk act) =>
    state.rebuild((b) => b..tags.add(act.tag));

TagState _onRemove(TagState state, RemoveTagOk act) =>
    state.rebuild((b) => b..tags.removeWhere((t) => t.id == act.tag.id));

TagState _onDelete(TagState state, DeleteTagOk act) =>
    state.rebuild((b) => b..tags.removeWhere((t) => t.id == act.tag.id));
