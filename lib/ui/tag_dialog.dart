import 'dart:async';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';

import 'package:koalabag/data/repository.dart';
import 'package:koalabag/model.dart';

class TagDialog extends StatefulWidget {
  final EntryInfo ei;

  TagDialog(this.ei);

  @override
  _State createState() => _State(ei);
}

class _State extends State<TagDialog> {
  final GlobalKey<AutoCompleteTextFieldState<_TagSuggestion>> tfKey =
      GlobalKey<AutoCompleteTextFieldState<_TagSuggestion>>();

  final EntryInfo ei;
  List<Tag> tags = List();
  BuiltList<_TagSuggestion> suggestions = BuiltList.of([]);
  bool _saving = false;
  String _label = "";

  _State(this.ei);

  @override
  void initState() {
    super.initState();
    final tagDao = Global().dao.tagDao;

    tagDao.getEntryTags(ei.id).then((BuiltList<Tag> ts) {
      setState(() {
        this.tags = ts.toList();
      });
    });

    tagDao.getAll().then((all) {
      setState(() {
        this.suggestions = BuiltList.of(all.map((tag) => _TagSuggestion(tag)));
        tfKey.currentState.updateSuggestions(this.suggestions.toList());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    const hInsets = EdgeInsets.symmetric(horizontal: 16.0);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Tags'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop(null);
            },
            icon: Icon(Icons.check),
            tooltip: 'Done',
          )
        ],
      ),
      body: Column(children: <Widget>[
        _saving ? LinearProgressIndicator(value: null) : Container(),
        Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(ei.title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0))),
        Padding(
            padding: hInsets,
            child: _textField(
              textChanged: (t) => _label = t,
              itemSubmitted: (suggestion) => _label = suggestion.tag.label,
              key: tfKey,
              onAddPressed: () async => _addTag(ei.id, _label),
            )),
        Expanded(
          child: Padding(
              padding: hInsets,
              child: _tagList(
                  tags: this.tags,
                  delete: (tag) async => _removeTag(ei.id, tag))),
        ),
      ]),
    );
  }

  Future<void> _addTag(int entryId, String label) async {
    tfKey.currentState.clear();

    setState(() {
      _saving = true;
    });

    final ITagDao tagDao = Global().dao.tagDao;

    try {
      await tagDao.add(entryId, label);

      final newTag = await tagDao.byLabel(label);
      setState(() {
        this.tags.add(newTag);
        this.suggestions =
            this.suggestions.rebuild((b) => b..add(_TagSuggestion(newTag)));
      });
    } catch (err) {
      print("Error adding tag: $err");
    }

    setState(() {
      _saving = false;
    });
  }

  Future<void> _removeTag(final int entryId, final Tag tag) async {
    setState(() {
      _saving = true;
    });

    final tagDao = Global().dao.tagDao;

    try {
      await tagDao.remove(entryId, tag);
      setState(() {
        this.tags.removeWhere((t) => t.id == tag.id);
      });
    } catch (err) {
      print("Error adding tag: $err");
    }

    setState(() {
      _saving = false;
    });
  }
}

class _TagSuggestion {
  final Tag tag;

  _TagSuggestion(this.tag);

  @override
  String toString() => this.tag.label;
}

Widget _textField(
    {@required void Function() onAddPressed,
    @required Function(_TagSuggestion) itemSubmitted,
    @required Function(String) textChanged,
    @required GlobalKey<AutoCompleteTextFieldState<_TagSuggestion>> key}) {
  return Row(children: <Widget>[
    Expanded(
        child: AutoCompleteTextField<_TagSuggestion>(
            itemSubmitted: itemSubmitted,
            key: key,
            clearOnSubmit: false,
            suggestions: [],
            itemBuilder: (context, suggested) =>
                ListTile(title: Text(suggested.tag.label)),
            itemSorter: (s1, s2) => s1.tag.label.compareTo(s2.tag.label),
            itemFilter: (suggestion, query) => suggestion.tag.label
                .toLowerCase()
                .startsWith(query.toLowerCase()),
            textChanged: textChanged)),
    IconButton(
        icon: Icon(Icons.add), onPressed: onAddPressed, tooltip: 'Add Tag'),
  ]);
}

Widget _tagList(
    {@required final List<Tag> tags, @required void Function(Tag) delete}) {
  return ListView.builder(
      itemCount: tags.length,
      itemBuilder: (context, idx) {
        final tag = tags[idx];
        return ListTile(
          leading: Icon(Icons.label),
          title: Text(tag.label),
          trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => delete(tag),
              tooltip: 'Remove Tag'),
        );
      });
}
