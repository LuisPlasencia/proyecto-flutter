import 'package:flutter/material.dart';

class PlaceholderWidgetDos extends StatelessWidget {
  final Color color;

  PlaceholderWidgetDos(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}