import 'package:flutter/material.dart';

import 'game_item.dart';

class GameItemAnimation extends StatelessWidget {
  final GameItem child;
  final Animation<double> animation;

  GameItemAnimation(this.child, this.animation);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          width: animation.value,
          height: animation.value,
          child: child,
        );
      },
      child: child,
    );
  }
}
