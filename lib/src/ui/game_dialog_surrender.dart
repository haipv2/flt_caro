import 'package:flutter/material.dart';

class GameDialogSurrender extends StatelessWidget {
  final title;
  final content;
  final VoidCallback callback;
  final actionText;

  GameDialogSurrender(this.title, this.content, this.callback,
      [this.actionText = "Quit"]);

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
