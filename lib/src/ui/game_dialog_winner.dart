import 'package:flutter/material.dart';

class GameDialogWinner extends StatelessWidget {
  final title;
  final content;
  final VoidCallback callback;
  final actionText;

  GameDialogWinner(this.title, this.content, this.callback,
      [this.actionText = ""]);

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: new Text(title),
      content: new Text(content),
      actions: <Widget>[
        new FlatButton(
          onPressed: callback,
          child: new Text(actionText),
          color: Colors.white,
        ),
      ],
    );
  }
}
