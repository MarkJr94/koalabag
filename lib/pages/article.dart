import 'package:async_loader/async_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:koalabag/model.dart';

class Article extends StatelessWidget {
  final Future<Entry> entry;
  final GlobalKey<AsyncLoaderState> _asyncLoaderState =
      new GlobalKey<AsyncLoaderState>();

  Article(this.entry);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Article"),
      ),
      body: SingleChildScrollView(
          child: AsyncLoader(
              key: _asyncLoaderState,
              initState: () => entry,
              renderLoad: () => CircularProgressIndicator(),
              renderError: ([e]) => Center(
                    child: Text(":( $e :("),
                  ),
              renderSuccess: ({data}) {
//                print("data = $data");
                return Html(
                  data: data.content,
                  defaultTextStyle: TextStyle(color: Colors.white),
                );
              })),
    );
  }
}
