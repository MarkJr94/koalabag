import 'package:flutter/material.dart';

Widget pad(Widget w, EdgeInsets insets) => Padding(padding: insets, child: w);

Widget enableTap(Widget w, void Function() onTap) =>
    GestureDetector(child: w, onTap: onTap);
