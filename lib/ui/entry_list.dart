import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:koalabag/redux/actions.dart' as act;
import 'package:koalabag/redux/entry.dart' as ent;
import 'package:koalabag/redux/app/state.dart';
import 'package:koalabag/model.dart';
import 'package:koalabag/ui.dart';

class EntryList extends StatefulWidget {
  final bool Function(Entry) filter;

//  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
//      new GlobalKey<RefreshIndicatorState>();

  EntryList({Key key, @required this.filter}) : super(key: key);

  @override
  State createState() {
    return EntryListState(filter: filter);
  }
}

class EntryListState extends State<EntryList>
    with AutomaticKeepAliveClientMixin<EntryList> {
  final bool Function(Entry) filter;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  EntryListState({@required this.filter});

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      key: UniqueKey(),
      distinct: true,
      converter: _ViewModel.fromStore(filter),
      builder: (BuildContext ctx, _ViewModel vm) {
        return RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: vm.fetch,
            child: ListView.builder(
                key: new UniqueKey(),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: vm.entryIds.length,
                itemBuilder: (context, idx) {
//                  if (entries != null) {
//                    final entry = entries[idx];
                  var id = vm.entryIds[idx];
                  return EntryCard(
                    entryId: id,
                    key: ValueKey(id),
                    onStarClick: vm.onStar,
                    onDeleteClick: vm.noOp(context),
                    onCheckClick: vm.onCheck,
                  );
//                  }
                }));
      },
      onWillChange: (_) {
        print("Built EntryList");
      },
    );
  }
}

class EntryListHolder {
  final void Function(int, Entry) onStar;
  final void Function(int, Entry) onCheck;
  final void Function(int, Entry) onDelete;
  final Future<void> Function() onRefresh;

  EntryListHolder(
      {@required this.onStar,
      @required this.onCheck,
      @required this.onDelete,
      @required this.onRefresh});
}

class _ViewModel {
  final Store<AppState> store;
  final BuiltList<int> entryIds;
  final bool Function(Entry) filter;

  _ViewModel(
      {@required this.store, @required this.entryIds, @required this.filter});

  static _ViewModel Function(Store<AppState>) fromStore(
      bool Function(Entry) filter) {
    return (Store<AppState> store) {
      final list = BuiltList.of(
          store.state.entry.entries.where(filter).map((e) => e.id));
      return _ViewModel(store: store, entryIds: list, filter: filter);
    };
  }

  Future<void> fetch() {
    final action = ent.FetchEntries(Completer());
    store.dispatch(action);
    return action.completer.future;
  }

  void refresh() {
    store.dispatch(act.AuthRefresh());
  }

  void onStar(int idx, Entry entry) {
    final action = act.ChangeEntry(
        entry: entry, starred: !entry.starred(), archived: entry.archived());
    store.dispatch(action);
  }

  void onCheck(int idx, Entry entry) {
    final action = act.ChangeEntry(
        entry: entry, archived: !entry.archived(), starred: entry.starred());
    store.dispatch(action);
  }

  void Function(int, Entry) noOp(BuildContext context) {
    final noOp = (idx, entry) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Unimplemented!"),
        backgroundColor: Colors.deepPurple,
        duration: Duration(milliseconds: 500),
      ));
    };

    return noOp;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          entryIds == other.entryIds;

  @override
  int get hashCode => entryIds.hashCode;
}
