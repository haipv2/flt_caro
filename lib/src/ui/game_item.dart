import 'package:flutter/material.dart';


class GameItem extends StatelessWidget{
  final id;
  String text;
  Color bg;
  bool enabled;
  Widget image;
  var activePlayer;
  GameItem(
      {this.id, this.text = "", this.bg = Colors.orange, this.enabled = true, this.image, this.activePlayer});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: image,
    );
  }
}
