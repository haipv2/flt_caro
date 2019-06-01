import 'dart:convert';

import 'package:flt_caro/src/blocs/login_bloc_provider.dart';
import 'package:flt_caro/src/common/common.dart';
import 'package:flt_caro/src/models/user.dart';
import 'package:flt_caro/src/ui/login_page.dart';
import 'package:flt_caro/src/ui/my_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/ui/tips_screen.dart';

void main() {
  SharedPreferences.getInstance().then((prefs) {
    runApp(MyApp(prefs));
  });
}

class MyApp extends StatefulWidget {
  final SharedPreferences preferences;
  User user;

  MyApp(this.preferences);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    String userJson = widget.preferences.getString(USER_PREFS_KEY);
    if (userJson != null && userJson.isNotEmpty) {
      Map userMap = jsonDecode(userJson);
      widget.user = User.fromJson(userMap);
    }
    GlobalKey<ScaffoldState> _mainScaffold = new GlobalKey<ScaffoldState>();

    Widget _scaffold() {
      bool seen = (widget.preferences.getBool('seen') ?? false);
      if (seen) {
        return Scaffold(
            key: _mainScaffold,
            body: widget.user == null ? Loginpage() : MyPage(widget.user));
      } else {
        return TipsScreen(prefs: widget.preferences);
      }
    }

    return LoginBlocProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Demo app',
        home: _scaffold(),
        routes: <String, WidgetBuilder>{
          MYPAGE: (BuildContext context) => MyPage(widget.user),
        },
      ),
    );
  }
}
