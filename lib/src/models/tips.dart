import 'package:flutter/material.dart';

class Tips {
  IconData icon;
  String title;
  String description;
  Widget extraWidget;

  Tips({this.icon, this.title, this.description, this.extraWidget}) {
    if (extraWidget == null) {
      extraWidget = new Container();
    }
  }
}
