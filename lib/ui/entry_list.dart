import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:koalabag/pages/article.dart';
import 'package:koalabag/redux/actions.dart' as act;
import 'package:koalabag/redux/entry.dart' as ent;
import 'package:koalabag/redux/app/state.dart';
import 'package:koalabag/model.dart';
import 'package:koalabag/ui.dart';

class EntryList extends StatefulWidget {
  final bool Function(EntryInfo) filter;
  final int Function(EntryInfo, EntryInfo) sort;

  EntryList({Key key, @required this.filter, @required this.sort})
      : super(key: key);

  @override
  State createState() {
    return _State(filter: filter, sort: sort);
  }
}

class _State extends State<EntryList>
    with AutomaticKeepAliveClientMixin<EntryList> {
  final bool Function(EntryInfo) filter;
  final int Function(EntryInfo, EntryInfo) sort;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  _State({@required this.filter, @required this.sort});

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        key: UniqueKey(),
        distinct: true,
        converter: _ViewModel.fromStore(filter, sort),
        builder: (BuildContext ctx, _ViewModel vm) {
          final cardController = _CardController(vm.store, ctx);

          return RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: vm.sync,
              child: ListView.builder(
                  key: new UniqueKey(),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: vm.entryIds.length,
                  itemBuilder: (context, idx) {
                    var id = vm.entryIds[idx];
                    return EntryCard(
                      entryId: id,
                      key: ValueKey(id),
                      controller: cardController,
                    );
                  }));
        },
        onWillChange: (_) {
          print("Built EntryList");
        });
  }
}

class _ViewModel {
  final Store<AppState> store;
  final BuiltList<int> entryIds;
  final bool Function(EntryInfo) filter;
  final int Function(EntryInfo, EntryInfo) sort;

  _ViewModel(
      {@required this.store,
      @required this.entryIds,
      @required this.filter,
      @required this.sort});

  static _ViewModel Function(Store<AppState>) fromStore(
      bool Function(EntryInfo) filter,
      int Function(EntryInfo, EntryInfo) sort) {
    return (Store<AppState> store) {
      final list = BuiltList.of(store.state.entry.entries
          .rebuild((b) => b..sort(sort))
          .where(filter)
          .map((e) => e.id));
      return _ViewModel(
          store: store, entryIds: list, filter: filter, sort: sort);
    };
  }

  Future<void> sync() {
    final action = ent.EntrySync(Completer());
    store.dispatch(action);
    return action.completer.future;
  }

  void refresh() {
    store.dispatch(act.AuthRefresh());
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

class _CardController implements EntryCardController {
  final Store<AppState> store;
  final BuildContext context;

  _CardController(this.store, this.context);

  void check(EntryInfo ei) {
    final action = act.ChangeEntry(
        entry: ei, archived: !ei.archived(), starred: ei.starred());
    store.dispatch(action);
  }

  void star(EntryInfo ei) {
    final action = act.ChangeEntry(
        entry: ei, archived: ei.archived(), starred: !ei.starred());
    store.dispatch(action);
  }

  void delete(EntryInfo ei) {
    print("Delete unimplemented");
  }

  void select(EntryInfo ei) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Article(ei.id),
      ),
    );
  }

  void manageTags(EntryInfo ei) {
    Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) {
          return TagDialog(ei);
        }));
  }
}
