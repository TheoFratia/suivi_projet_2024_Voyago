import 'package:flutter/material.dart';

Future<void> NavigateAfterDelay(Widget Function() pageBuilder, int seconds, BuildContext context) async {
  Future.delayed(Duration(seconds: seconds), () {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => pageBuilder()),
    );
  });
}