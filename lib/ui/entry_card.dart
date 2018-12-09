import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:koalabag/model.dart';
import 'package:koalabag/redux/app/state.dart';

typedef EntryCardCallback = void Function(int idx, Entry entry);

class EntryCard extends StatelessWidget {
  final int entryId;
  final EntryCardCallback onCheckClick;
  final EntryCardCallback onStarClick;
  final EntryCardCallback onDeleteClick;

//  Entry entry;

  EntryCard({
    Key key,
    @required this.entryId,
    @required this.onCheckClick,
    @required this.onStarClick,
    @required this.onDeleteClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Entry>(
      distinct: true,
      converter: (store) =>
          store.state.entry.entries.firstWhere((e) => e.id == entryId),
      builder: (context, entry) {
        return Card(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _mainColumn(context, entry),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _mainColumn(BuildContext context, Entry entry) {
    final tt = Theme.of(context).textTheme;

    final fav = entry.starred() ? Icons.star : Icons.star_border;
    final check =
        entry.archived() ? Icons.check_circle : Icons.check_circle_outline;

    final bottomBar = Row(
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
                  onPressed: () => onCheckClick(entryId, entry)),
              IconButton(
                  icon: Icon(fav),
                  onPressed: () => onStarClick(entryId, entry)),
              IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => onDeleteClick(entryId, entry)),
            ],
          ),
        ),
      ],
    );
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

    mainColumn.add(bottomBar);

    return mainColumn;
  }
}
