import 'package:flutter/material.dart';

class GameItem extends AnimatedWidget {
  final id;
  String text;
  Color bg;
  bool enabled;
  Widget image;
  var activePlayer;

  GameItem({Key key, Animation<
      double> animation, this.id, this.text = "", this.bg = Colors
      .orange, this.enabled = true, this.image, this.activePlayer})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> _animation = listenable;
    return Center(
      child: Container(
        height: _animation.value,
        width: _animation.value,
        child: image,
      ),
    );
  }

}


//class GameItem extends StatelessWidget{
//  final id;
//  String text;
//  Color bg;
//  bool enabled;
//  Widget image;
//  var activePlayer;
//  GameItem(
//      {this.id, this.text = "", this.bg = Colors.orange, this.enabled = true, this.image, this.activePlayer});
//
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      child: image,
//    );
//  }
//}
