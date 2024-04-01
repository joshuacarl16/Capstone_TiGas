import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message, [Duration? duration]) {
  final snackBar = SnackBar(
    content: Text(message),
    duration: duration ?? Duration(seconds: 3), // Default duration of 2 seconds
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
