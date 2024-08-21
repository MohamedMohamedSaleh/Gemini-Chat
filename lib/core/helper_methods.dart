import 'package:flutter/material.dart';

void showMyAnimatedDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String actionText,
  required Function(bool) negativeButtonAction,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Container();
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
          scale: Tween<double>(begin: 05, end: 1.0).animate(animation),
          child: FadeTransition(
            opacity: animation,
            child: AlertDialog(
              title: Text(
                title,
                textAlign: TextAlign.center,
              ),
              content: Text(
                content,
                textAlign: TextAlign.center,
              ),
              actions: [
                TextButton(
                  child: const Text('cancel'),
                  onPressed: () {
                    negativeButtonAction(false);
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(actionText),
                  onPressed: () {
                    negativeButtonAction(true);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ));
    },
  );
}
