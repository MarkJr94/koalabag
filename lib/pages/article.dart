import 'package:async_loader/async_loader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:koalabag/data/repository.dart';
import 'package:koalabag/model.dart';
import 'package:koalabag/redux/app.dart';
import 'package:koalabag/redux/entry/actions.dart';
import 'package:koalabag/widget_utils.dart' as wu;

class Article extends StatelessWidget {
  final int id;
  final GlobalKey<AsyncLoaderState> _asyncLoaderState =
      new GlobalKey<AsyncLoaderState>();

  Article(this.id);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (Store store) => _ViewModel.fromStore(store, id),
      builder: (BuildContext context, _ViewModel vm) {
        final ei = vm.entryInfo;
        final theme = Theme.of(context);
        final tt = theme.textTheme;

        return Scaffold(
          appBar: _appBar(vm, ei),
          body: SingleChildScrollView(
              child: AsyncLoader(
                  key: _asyncLoaderState,
                  initState: () {
                    return Global().dao.entryDao.getHydrated(vm.id);
                  },
                  renderLoad: () => CircularProgressIndicator(),
                  renderError: ([e]) => Center(
                        child: Text(":( $e :("),
                      ),
                  renderSuccess: ({data}) {
//                print("data = $data");
                    final entry = (data as Entry);
                    final body = Container(
                      padding: EdgeInsets.all(8.0),
                      child: _mainColumn(entry, tt),
                    );
                    return body;
                  })),
          bottomNavigationBar: _bottomAppBar(context, ei, vm),
        );
      },
    );
  }

  AppBar _appBar(_ViewModel vm, EntryInfo ei) {
    return AppBar(
      title: Text(vm.entryInfo.title),
    );
  }

  BottomAppBar _bottomAppBar(
      BuildContext context, EntryInfo ei, _ViewModel vm) {
    return BottomAppBar(
      color: Theme.of(context).primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
              tooltip: "Archive",
              icon: Icon(ei.archived() ? Icons.unarchive : Icons.archive),
              onPressed: vm.archive),
          IconButton(
              tooltip: "Star",
              icon: Icon(ei.starred() ? Icons.star : Icons.star_border),
              onPressed: vm.star),
          IconButton(tooltip: "Tags", icon: Icon(Icons.label), onPressed: null),
          IconButton(
              tooltip: "Decrease Text Size",
              icon: Icon(Icons.remove),
              onPressed: null),
          IconButton(
              tooltip: "Increase Text Size",
              icon: Icon(Icons.add),
              onPressed: null),
        ],
      ),
    );
  }

  Column _mainColumn(Entry entry, TextTheme tt) {
    final title = Text(
      entry.title,
      style: tt.title,
      textAlign: TextAlign.start,
    );

    final domainName = InkWell(
        child: Text(
          entry.domainName,
          style: TextStyle(
            color: Colors.lightBlue,
            decoration: TextDecoration.underline,
          ),
          textAlign: TextAlign.start,
        ),
        onTap: () async => await launch(entry.url));

    final readTime = Text('Reading time: ${entry.readingTime}min');

    final image = entry.previewPicture == null
        ? Container()
        : CachedNetworkImage(
            imageUrl: entry.previewPicture,
            placeholder: CircularProgressIndicator(),
            errorWidget: Icon(Icons.error),
            height: 128.0,
            width: double.infinity,
            fit: BoxFit.fitWidth,
          );

    final insets = EdgeInsets.symmetric(vertical: 4.0);

    final kids = <Widget>[
      title,
      domainName,
      image,
      readTime,
      Divider(),
      Html(
        data: entry.content,
        defaultTextStyle: tt.body1.apply(fontSizeFactor: 1.5),
        onLinkTap: (link) async => await launch(link),
      )
    ].map((w) => wu.pad(w, insets));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.of(kids),
    );
  }
}

class _ViewModel {
  final EntryInfo entryInfo;
  final int id;
  final Store<AppState> store;

  _ViewModel(this.id, this.entryInfo, this.store);

  factory _ViewModel.fromStore(Store<AppState> store, int id) {
    final entryInfo = store.state.entry.entries.firstWhere((ei) => ei.id == id);
    return _ViewModel(id, entryInfo, store);
  }

  void star() {
    store.dispatch(ChangeEntry(
        archived: entryInfo.archived(),
        starred: !entryInfo.starred(),
        entry: entryInfo));
  }

  void archive() {
    store.dispatch(ChangeEntry(
        archived: !entryInfo.archived(),
        starred: entryInfo.starred(),
        entry: entryInfo));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          entryInfo == other.entryInfo &&
          id == other.id;

  @override
  int get hashCode => entryInfo.hashCode ^ id.hashCode;
}
