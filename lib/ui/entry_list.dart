import 'package:flutter/material.dart';
import 'package:built_collection/built_collection.dart';

import 'package:koalabag/model.dart';
import 'package:koalabag/ui.dart';

class EntryList extends StatelessWidget {
  final BuiltList<Entry> entries;
  final EntryListHolder _listener;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  EntryList(
      {Key key, @required this.entries, @required EntryListHolder listener})
      : _listener = listener,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _listener.onRefresh,
        child: ListView.builder(
            key: new UniqueKey(),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: entries?.length ?? 0,
            itemBuilder: (context, idx) {
              if (entries != null) {
                final entry = entries[idx];
                return EntryCard(
                  entry: entry,
                  key: ValueKey(entry.id),
                  onStarClick: () => _listener.onStar(idx, entry),
                  onDeleteClick: () => _listener.onDelete(idx, entry),
                  onCheckClick: () => _listener.onCheck(idx, entry),
                );
              }
            }));
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
