import 'package:ticcar5/src/ui/game_dialog_animation.dart';
import 'package:ticcar5/src/ui/game_dialog_winner.dart';
import 'package:flutter/material.dart';

void main() => runApp(TestPage());

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animation = Tween(begin: -1.0, end: 0.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOutBack));

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _animationController.forward();
    return MaterialApp(
      home: GameDialogAnimate(
          child: GameDialogWinner('title', 'content', () {},"QUIT"),
          animation: _animation),
    );
  }
}
