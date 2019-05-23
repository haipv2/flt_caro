import 'dart:convert';

import 'package:english_words/english_words.dart';
import 'package:flt_caro/src/blocs/login_bloc_provider.dart';
import 'package:flt_caro/src/common/common.dart';
import 'package:flt_caro/src/models/user.dart';
import 'package:flt_caro/src/ui/login_page.dart';
import 'package:flt_caro/src/ui/my_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final aiName = WordPair.random();
    if (userJson != null && userJson.isNotEmpty) {
      Map userMap = jsonDecode(userJson);
      widget.user = User.fromJson(userMap);
    }
    GlobalKey<ScaffoldState> _mainScaffold = new GlobalKey<ScaffoldState>();

    return LoginBlocProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Demo app',
        home: Scaffold(key: _mainScaffold,body: widget.user == null ? Loginpage() : MyPage(widget.user)),
        routes: <String, WidgetBuilder>{
          MYPAGE: (BuildContext context) => MyPage(widget.user),
        },
      ),
    );
  }
}

