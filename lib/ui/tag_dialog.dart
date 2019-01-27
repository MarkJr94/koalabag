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
  final EntryInfo ei;
  final GlobalKey<AutoCompleteTextFieldState<_TagSuggestion>> tfKey =
      GlobalKey<AutoCompleteTextFieldState<_TagSuggestion>>();

  List<Tag> tags = List();
  BuiltList<_TagSuggestion> suggestions = BuiltList.of([]);
  bool _saving = false;

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Tags'),
        actions: [
          FlatButton(
              onPressed: () {
                Navigator.of(context).pop(null);
              },
              child: Text('CANCEL', style: TextStyle(color: Colors.white)))
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(ei.title,
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0)),
              _textField(),
              _tagList(),
            ]),
      ),
    );
  }

  Widget _modal(Widget w) {
    return Stack(children: <Widget>[
      (_saving
          ? Opacity(
              opacity: 0.3,
              child: ModalBarrier(dismissible: false, color: Colors.grey))
          : Container()),
      (_saving ? Center(child: CircularProgressIndicator()) : Container()),
      w,
    ]);
  }

  Widget _textField() {
    final actf = AutoCompleteTextField<_TagSuggestion>(
      itemSubmitted: (item) {
        return item.tag.label;
      },
      key: tfKey,
      clearOnSubmit: false,
      suggestions: [],
      itemBuilder: (context, suggested) =>
          ListTile(title: Text(suggested.tag.label)),
      itemSorter: (s1, s2) => s1.tag.label.compareTo(s2.tag.label),
      itemFilter: (suggestion, query) =>
          suggestion.tag.label.toLowerCase().startsWith(query.toLowerCase()),
    );

    return Row(children: <Widget>[
      Expanded(child: actf),
      IconButton(
          icon: Icon(Icons.add),
          onPressed: () async => _addTag(ei.id, tfKey.currentState.currentText),
          tooltip: 'Add Tag'),
    ]);
  }

  Widget _tagList() {
    return Expanded(
        child: ListView.builder(
            itemCount: tags.length,
            itemBuilder: (context, idx) {
              final tag = tags[idx];
              print('tag = $tag');
              return ListTile(
                leading: Icon(Icons.label),
                title: Text(tag.label),
                trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async => _removeTag(ei.id, tag),
                    tooltip: 'Remove Tag'),
              );
            }));
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
