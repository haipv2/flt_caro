import 'package:flutter/material.dart';

class GameItem extends StatefulWidget {
  final id;
  String text;
  Color bg;
  bool enabled;
  Widget image;
  var activePlayer;

  GameItem({
    Key key,
    this.id,
    this.text = "",
    this.bg = Colors.orange,
    this.enabled = true,
    this.image,
    this.activePlayer,
  });

  @override
  _GameItemState createState() => _GameItemState();
}

class _GameItemState extends State<GameItem>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    _animation = Tween<double>(begin: 0.0, end: 50.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.elasticIn))
          ..addListener(() {
            setState(() {});
          });

    _controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(_animation.value);
    return Center(
      child: Container(
        height: _animation.value,
        width: _animation.value,
        child: widget.image,
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
