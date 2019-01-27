import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:koalabag/model.dart';
import 'package:koalabag/redux/app/state.dart';
import 'package:koalabag/widget_utils.dart' as w;

class EntryCard extends StatelessWidget {
  final int entryId;
  final EntryCardController controller;

  EntryCard({
    Key key,
    @required this.entryId,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return StoreConnector<AppState, EntryInfo>(
      distinct: true,
      converter: (store) =>
          store.state.entry.entries.firstWhere((e) => e.id == entryId),
      builder: (context, entry) {
        return Card(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _mainColumn(context, entry, tt),
                _bottomBar(entry, tt)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _mainColumn(BuildContext context, EntryInfo entry, TextTheme tt) {
    final tt = Theme.of(context).textTheme;

    return w.enableTap(
        Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 4.0),
              child: Text(
                entry.title,
                style: tt.headline,
                softWrap: true,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 4.0),
              child: Text(
                entry.domainName,
                style: tt.caption,
                softWrap: true,
              ),
            ),
            null != entry.previewPicture
                ? CachedNetworkImage(
                    imageUrl: entry.previewPicture,
                    placeholder: CircularProgressIndicator(),
                    errorWidget: Icon(Icons.error),
                    height: 128.0,
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                  )
                : Container(),
          ],
        ),
        () => controller.select(entry));
  }

  Widget _bottomBar(final EntryInfo entry, final TextTheme tt) {
    final fav = entry.starred() ? Icons.star : Icons.star_border;
    final check =
        entry.archived() ? Icons.check_circle : Icons.check_circle_outline;

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: Icon(Icons.access_time),
        ),
        Expanded(
          child: Text(
            "${entry.readingTime} min",
            style: tt.caption,
          ),
        ),
        ButtonTheme.bar(
          // make buttons use the appropriate styles for cards
          child: ButtonBar(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.label),
                onPressed: () => controller.manageTags(entry),
                tooltip: 'Tags',
              ),
              IconButton(
                icon: Icon(check),
                onPressed: () => controller.check(entry),
                tooltip: 'Archive',
              ),
              IconButton(
                icon: Icon(fav),
                onPressed: () => controller.star(entry),
                tooltip: 'Favorite',
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => controller.delete(entry),
                tooltip: 'Delete',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

abstract class EntryCardController {
  void check(EntryInfo entry);
  void star(EntryInfo entry);
  void delete(EntryInfo entry);
  void select(EntryInfo entry);
  void manageTags(EntryInfo entry);
}
