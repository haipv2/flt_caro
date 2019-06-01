import 'package:flutter/material.dart';

class FightingBar extends AnimatedWidget {
  FightingBar({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Center(
      child: Transform.scale(
        scale: 1,
        child: Container(
          height: animation.value,
          width: animation.value,
          child: Stack(
            children: <Widget>[
              Center(
                  child: Image.asset(
                'assets/images/letsgo.gif',
                fit: BoxFit.fill,
                height: double.infinity,
                width: double.infinity,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
