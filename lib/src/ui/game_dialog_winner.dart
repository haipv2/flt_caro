import 'package:flutter/material.dart';

class GameDialogWinner extends StatelessWidget {
  final title;
  final content;
  final VoidCallback callback;
  final actionText;

  GameDialogWinner(this.title, this.content, this.callback,
      [this.actionText = "Quit"]);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(dialogBackgroundColor: Colors.white70),
      child: Builder(builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0.0,
          backgroundColor: Colors.lime,
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: Colors.yellow),
                  child: Center(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.only(left: 15),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      content,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: double.infinity,
                  height: 30,
                  decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15))),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      child: FlatButton(
                        onPressed: callback,
                        child: Text(
                          actionText,
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
