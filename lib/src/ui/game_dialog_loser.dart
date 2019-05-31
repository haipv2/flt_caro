import 'package:flt_caro/src/models/user.dart';
import 'package:flutter/material.dart';

import 'my_page.dart';

class GameDialogLoser extends StatelessWidget {
  final title;
  final content;
  final VoidCallback callback;
  final actionText;
  User player;

  GameDialogLoser(this.title, this.content, this.callback,
      [this.actionText = "Play Again", this.player]);

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: new Text(title),
      content: new Text(content),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => MyPage(player)));
          },
          child: new Text('Main screen'),
          color: Colors.white,
        ),
        new FlatButton(
          onPressed: callback,
          child: new Text(actionText),
          color: Colors.white,
        )
      ],
    );
  }
}
