import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddEntryDialog extends StatefulWidget {
  @override
  AddEntryDialogState createState() => new AddEntryDialogState();
}

class AddEntryDialogState extends State<AddEntryDialog> {
  final _url = TextEditingController();

  @override
  void initState() {
    super.initState();
    final Future<Uri> urlFuture =
        Clipboard.getData(Clipboard.kTextPlain).then((clipboardData) {
      final uri = Uri.parse(clipboardData.text);
      return uri;
    });

    urlFuture.then((uri) {
      setState(() {
        _url.text = uri.toString();
      });
    }).catchError((_) {});
  }

  @override
  void dispose() {
    _url.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextFormField urlField = TextFormField(
      keyboardType: TextInputType.url,
      controller: _url,
      autofocus: true,
      validator: (s) {
        try {
          Uri.parse(s);
          return null;
        } catch (_) {
          return 'Must be proper url';
        }
      },
      decoration:
          InputDecoration(labelText: 'URL', hintText: 'eg. example.com'),
    );

    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Article'),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(null);
                },
                child: new Text('CANCEL',
                    style: Theme.of(context)
                        .textTheme
                        .subhead
                        .copyWith(color: Colors.white))),
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(Uri.parse(_url.text));
                },
                child: new Text('ADD',
                    style: Theme.of(context)
                        .textTheme
                        .subhead
                        .copyWith(color: Colors.white))),
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: urlField,
          ),
        ));
  }
}
