import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';

import 'package:koalabag/model.dart';
import 'package:koalabag/data/api.dart';
import 'package:koalabag/data/database.dart';
import 'package:koalabag/data/repository.dart';

class EntryDao implements IEntryDao {
  final IEntryApi _api;
//  final EntryProvider _provider;
  final EntryInfoProvider _infoProvider;
  final EntryContentProvider _contentProvider;

  EntryDao(
      {@required IEntryApi api,
      @required EntryInfoProvider infoProvider,
      @required EntryContentProvider contentProvider})
      : _api = api,
        _infoProvider = infoProvider,
        _contentProvider = contentProvider;

  @override
  Future<EntryInfo> add(Uri articleUri) async {
    final e = await _api.add(articleUri);
    var info = e.toInfo();
    await _infoProvider.insert(info);
    await _contentProvider.insert(e.toContent());
    return info;
  }

  @override
  Future<EntryInfo> getOne(final int id) {
    return _infoProvider.get(id);
  }

  @override
  Future<BuiltList<EntryInfo>> getAll() {
    return _infoProvider.loadAll();
  }

  Future<bool> mergeSaveEntries(BuiltList<Entry> entries) async {
    final infos = entries.map((e) => e.toInfo());
    final contents = entries.map((e) => e.toContent());

    final r1 = await _infoProvider.saveAll(infos);
    final r2 = await _contentProvider.saveAll(contents);

    return r1 != 0 && r1 == r2;
  }

  @override
  Future<EntryInfo> changeEntry(EntryInfo ei,
      {bool starred, bool archived}) async {
    var entry = await hydrate(ei);

    var updated =
        await _api.changeEntry(entry, starred: starred, archived: archived);

    var info = updated.toInfo();

    await _infoProvider.insert(info);
    await _contentProvider.insert(updated.toContent());

    return info;
  }

  Future<void> sync() async {
    print("sync starts");

    final localIds = BuiltSet.of(await _infoProvider.allIds());
    final latest = await _infoProvider.getLatest();

    final entryStream = _api.all(since: latest.millisecondsSinceEpoch);

    print("localIds = $localIds");

    final remoteEntries = await entryStream.fold(BuiltList<Entry>(),
        (BuiltList<Entry> acc, BuiltList<Entry> batch) {
      return acc.rebuild((b) => b..addAll(batch));
    });

    final remoteIds = BuiltSet.of(remoteEntries.map((e) => e.id));

    final removed =
        BuiltList.of(localIds.where((id) => !remoteIds.contains(id)));

    print("Removed ids = $removed");

    if (removed.isNotEmpty) {
      await _infoProvider.deleteMany(removed);
      await _contentProvider.deleteMany(removed);
    }

    await mergeSaveEntries(remoteEntries);
  }

  Future<Entry> hydrate(EntryInfo ei) async {
    var content = await _contentProvider.get(ei.id);
    return Entry.unSplit(ei, content);
  }

  Future<Entry> getHydrated(int id) async {
    final content = await _contentProvider.get(id);
    final info = await _infoProvider.get(id);

    return Entry.unSplit(info, content);
  }
}
