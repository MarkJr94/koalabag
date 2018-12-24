import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:koalabag/model.dart';
import 'package:koalabag/redux/app/state.dart';

typedef EntryCardCallback = void Function(int idx, EntryInfo entry);

class EntryCard extends StatelessWidget {
  final int entryId;
  final EntryCardCallback onCheckClick;
  final EntryCardCallback onStarClick;
  final EntryCardCallback onDeleteClick;
  final void Function(EntryInfo) onEntryTap;

//  Entry entry;

  EntryCard({
    Key key,
    @required this.entryId,
    @required this.onCheckClick,
    @required this.onStarClick,
    @required this.onDeleteClick,
    @required this.onEntryTap,
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

    var mainColumn = <Widget>[
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
    ];

    if (null != entry.previewPicture) {
      final image = CachedNetworkImage(
        imageUrl: entry.previewPicture,
        placeholder: CircularProgressIndicator(),
        errorWidget: Icon(Icons.error),
        height: 128.0,
        width: double.infinity,
        fit: BoxFit.fitWidth,
      );

      mainColumn.add(image);
    }

    return _enableTap(
        Column(
          children: mainColumn,
        ),
        entry);
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
                icon: Icon(check),
                onPressed: () => onCheckClick(entryId, entry),
                tooltip: 'Archive',
              ),
              IconButton(
                icon: Icon(fav),
                onPressed: () => onStarClick(entryId, entry),
                tooltip: 'Favorite',
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => onDeleteClick(entryId, entry),
                tooltip: 'Delete',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _enableTap(Widget w, EntryInfo entry) {
    return GestureDetector(
      child: w,
      onTap: () => onEntryTap(entry),
    );
  }
}
