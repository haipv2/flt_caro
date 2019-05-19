import 'package:flutter/material.dart';

class Cell extends StatelessWidget {
  IconData icon;
  Cell(BuildContext context, int i, activePlayer, icon);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(Icons.insert_emoticon),
    );
  }
}
