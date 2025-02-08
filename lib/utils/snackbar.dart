import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: content.text.make(),
    ),
  );
}
