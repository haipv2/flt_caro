import 'package:flutter/material.dart';

import 'game_item.dart';

class GameItemAnimation extends StatelessWidget {
  GameItem child;
  Animation<double> animation;

  GameItemAnimation(this.child, this.animation);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return
        Container(
          width: animation.value,
          height: animation.value,
          child: child,
        );
//          Transform(
//          transform:
//              Matrix4.translationValues(animation.value * width, 0.0, 0.0),
//          child: child,
//        );
      },
      child: child,
    );
  }
}
