import 'package:built_collection/built_collection.dart';
import 'package:koalabag/model/entry_info.dart';

import 'package:koalabag/model/tag.dart';
import 'package:koalabag/data/api.dart';
import 'package:koalabag/data/database.dart';
import 'package:koalabag/data/repository.dart';

// TODO
class TagDao implements ITagDao {
  final ITagApi _api;
  final TagProvider _provider;

  TagDao(ITagApi api, TagProvider provider)
      : _provider = provider,
        _api = api;

  @override
  Future<EntryInfo> add(int entryId, final Tag tag) {
    // TODO: implement add
    return null;
  }

  @override
  Future<EntryInfo> remove(int entryId, final Tag tag) {
    // TODO: implement remove
    return null;
  }

  Future<BuiltList<Tag>> getEntryTags(int entryId) {
    // TODO: implement getEntryTags
    return null;
  }

  @override
  Future<Tag> byId(int id) {
    // TODO: implement byId
    return null;
  }

  @override
  Future<Tag> byLabel(String label) {
    // TODO: implement byLabel
    return null;
  }

  @override
  Future<void> delete(Tag tag) {
    // TODO: implement delete
    return null;
  }

  @override
  Future<void> deleteMany(BuiltList<Tag> tags) {
    // TODO: implement deleteMany
    return null;
  }

  @override
  Future<BuiltList<Tag>> getAll() {
    // TODO: implement getAll
    return null;
  }

  @override
  Future<void> sync() {
    // TODO: implement sync
    return null;
  }
}
