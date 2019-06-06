import 'package:flutter/material.dart';

class Tips {
  Widget child;
  String title;
  String description;
  Widget extraWidget;

  Tips({this.child, this.title, this.description, this.extraWidget}) {
    if (extraWidget == null) {
      extraWidget = new Container();
    }
  }
}
