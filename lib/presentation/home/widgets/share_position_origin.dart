import 'package:flutter/material.dart';

Rect sharePositionOrigin(BuildContext context) {
  final box = context.findRenderObject() as RenderBox;
  return box.localToGlobal(Offset.zero) & box.size;
}
