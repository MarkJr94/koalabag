import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:koalabag/redux/app/state.dart';
import 'package:koalabag/model.dart';

class EntrySearch extends StatelessWidget {
  final String query;
  final bool isSearch;

  EntrySearch(this.query, {this.isSearch = true});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) {
        return _ViewModel(store.state.entry.entries, query);
      },
      builder: (BuildContext context, _ViewModel vm) {
        return ListView.builder(
            itemCount: vm.entries.length, itemBuilder: searchBuilder(vm));
      },
    );
  }

  Widget Function(BuildContext, int) searchBuilder(_ViewModel vm) {
    return (context, idx) {
      return ListTile(
        leading: Icon(Icons.book),
        title: Text(vm.entries[idx].title),
        subtitle: Text(vm.entries[idx].domainName),
      );
    };
  }
}

class _ViewModel {
  BuiltList<EntryInfo> entries;
  final String query;

  _ViewModel(BuiltList<EntryInfo> entries, this.query) {
    this.entries = BuiltList.of(entries.where((e) {
      return e.title.toLowerCase().contains(query.toLowerCase());
    }));

    print("Search has ${this.entries.length} results");
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          entries == other.entries &&
          query == other.query;

  @override
  int get hashCode => entries.hashCode ^ query.hashCode;
}
