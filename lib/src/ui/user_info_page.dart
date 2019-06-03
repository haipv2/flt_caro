import 'package:ticcar5/src/models/user.dart';
import 'package:flutter/material.dart';

import '../common/common.dart';

class UserInfo extends StatelessWidget {
  final User user;
  final String imageUrl;

  UserInfo(this.user, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User profile'),
      ),
      body: Column(
        children: <Widget>[
          Center(
              child: Column(children: <Widget>[
            Container(
                width: 100,
                height: 100,
                child: Hero(tag: USER_AVA_TAG, child: Image.asset(imageUrl))),
            Text(
              'Hello ${user.firstname} ${user.lastname}',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'indie flower',
              ),
            )
          ])),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: SizedBox(
                  width: 10,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'First name:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'indie flower',
                  ),
                ),
              ),
              Expanded(flex: 4, child: Text(user.firstname)),
              Expanded(
                flex: 1,
                child: SizedBox(
                  width: 1,
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: SizedBox(
                  width: 10,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Last Name:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'indie flower',
                  ),
                ),
              ),
              Expanded(flex: 4, child: Text(user.lastname)),
              Expanded(
                flex: 1,
                child: SizedBox(
                  width: 1,
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: SizedBox(
                  width: 10,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Login Id:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'indie flower',
                  ),
                ),
              ),
              Expanded(flex: 4, child: Text(user.loginId)),
              Expanded(
                flex: 1,
                child: SizedBox(
                  width: 1,
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: SizedBox(
                  width: 10,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Email:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'indie flower',
                  ),
                ),
              ),
              Expanded(flex: 4, child: Text(user.email)),
              Expanded(
                flex: 1,
                child: SizedBox(
                  width: 1,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
