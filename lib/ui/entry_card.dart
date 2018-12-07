import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:koalabag/model.dart';

class EntryCard extends StatelessWidget {
  final Entry entry;
  final VoidCallback onCheckClick;
  final VoidCallback onStarClick;
  final VoidCallback onDeleteClick;

  const EntryCard(
      {Key key,
      @required this.entry,
      @required this.onCheckClick,
      @required this.onStarClick,
      @required this.onDeleteClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    final fav = entry.isStarred() ? Icons.star : Icons.star_border;

    var mainColumn = <Widget>[
      Text(
        entry.title,
        style: tt.headline,
        softWrap: true,
      ),
      ButtonTheme.bar(
        // make buttons use the appropriate styles for cards
        child: ButtonBar(
          children: <Widget>[
            IconButton(icon: Icon(Icons.check), onPressed: onCheckClick),
            IconButton(icon: Icon(fav), onPressed: onStarClick),
            IconButton(icon: Icon(Icons.delete), onPressed: onDeleteClick),
          ],
        ),
      ),
    ];

    if (null != entry.preview_picture) {
      final image = CachedNetworkImage(
        imageUrl: entry.preview_picture,
        placeholder: new CircularProgressIndicator(),
        errorWidget: new Icon(Icons.error),
        height: 128.0,
        width: double.infinity,
        fit: BoxFit.fitWidth,
      );

      mainColumn.insert(1, image);
    }

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: mainColumn,
      ),
    );
  }
}
