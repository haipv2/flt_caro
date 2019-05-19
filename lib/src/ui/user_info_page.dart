import 'package:flt_caro/src/models/user.dart';
import 'package:flutter/material.dart';

class UserInfo extends StatelessWidget {
  User user;

  UserInfo(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User profile'),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'First Name:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(user.firstname),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Last Name:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(user.lastname),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Email:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(user.email),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
