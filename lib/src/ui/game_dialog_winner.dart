import 'package:flutter/material.dart';

void main() => runApp(GameDialogWinner('title', 'content', () {}));

class GameDialogWinner extends StatelessWidget {
  final title;
  final content;
  final VoidCallback callback;
  final actionText;

  GameDialogWinner(this.title, this.content, this.callback,
      [this.actionText = "Play again!"]);

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
