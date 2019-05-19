import 'dart:async';

import 'package:flt_caro/src/ui/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Duration five;
  Timer t2;
  String routeName;

  @override
  void initState() {
    super.initState();
    five = const Duration(seconds: 3);
    t2 = new Timer(five, () {
      goToMainPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(color: Colors.lightBlueAccent),
      padding: EdgeInsets.all(10),
      child: Text("Welcome splash screen"),
    ));
  }

  void goToMainPage() async {
//    Navigator.of(context).pushReplacement(
//        MaterialPageRoute(builder: (BuildContext context) => Loginpage()));
  }
}
