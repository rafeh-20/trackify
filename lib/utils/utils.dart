import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), backgroundColor: Colors.red),
  );
}

void showStreakToast(int streakCount) {
  Fluttertoast.showToast(
    msg: "🎉 New Streak Milestone: $streakCount days!",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.green,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
