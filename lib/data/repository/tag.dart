import 'package:built_collection/built_collection.dart';

import 'package:koalabag/model/tag.dart';
import 'package:koalabag/model/tag_to_entry.dart';
import 'package:koalabag/data/api.dart';
import 'package:koalabag/data/database.dart';
import 'package:koalabag/data/repository.dart';

class TagDao implements ITagDao {
  final ITagApi _api;
  final TagProvider _provider;
  final TagToEntryProvider _tagToEntryProvider;

  TagDao(
      ITagApi api, TagProvider provider, TagToEntryProvider tagToEntryProvider)
      : _api = api,
        _provider = provider,
        _tagToEntryProvider = tagToEntryProvider;

  @override
  Future<Tag> add(int entryId, final String label) async {
    final tags = await _api.addToEntry(entryId, [label]);
    await _provider.insertMany(tags);

    await _tagToEntryProvider.insertMany(tags.map((t) => TagToEntry((b) => b
      ..tagId = t.id
      ..entryId = entryId)));
    return tags.firstWhere((t) => t.label == label);
  }

  @override
  Future<BuiltList<Tag>> addMany(
      int entryId, final Iterable<String> labels) async {
    final tags = await _api.addToEntry(entryId, labels);
    await _provider.insertMany(tags);
    await _tagToEntryProvider.insertMany(tags.map((t) => TagToEntry((b) => b
      ..tagId = t.id
      ..entryId = entryId)));
    return tags;
  }

  @override
  Future<void> remove(int entryId, final Tag tag) async {
    await _api.removeFromEntry(entryId, tag.id);
    await _tagToEntryProvider.delete(entryId, tag.id);
  }

  Future<BuiltList<Tag>> getEntryTags(int entryId) async {
    final tagIds = await _tagToEntryProvider.getByEntryId(entryId);
    return await _provider.getMany(tagIds.map((tte) => tte.tagId));
  }

  @override
  Future<Tag> byId(int id) async {
    return await _provider.get(id);
  }

  @override
  Future<Tag> byLabel(String label) async {
    return await _provider.getByLabel(label);
  }

  @override
  Future<void> delete(Tag tag) async {
    await _api.deleteById(tag.id);
    await _provider.delete(tag.id);
  }

  @override
  Future<void> deleteMany(Iterable<Tag> tags) async {
    await _api.deleteManyByLabel(tags.map((tag) => tag.label));
    await _provider.deleteMany(tags.map((tag) => tag.id));
  }

  @override
  Future<BuiltList<Tag>> getAll() async {
    return await _provider.loadAll();
  }
}
