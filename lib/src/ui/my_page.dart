import 'dart:async';
import 'dart:io';

import 'package:english_words/english_words.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flt_caro/src/blocs/mypage_bloc.dart';
import 'package:flt_caro/src/common/common.dart';
import 'package:flt_caro/src/models/user.dart';
import 'package:flt_caro/src/ui/game_page.dart';
import 'package:flt_caro/src/ui/login_page.dart';
import 'package:flt_caro/src/ui/user_list_page.dart';
import 'package:flt_caro/src/utils/map_utils.dart';
import 'package:flt_caro/src/utils/shared_preferences_utils.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../common/game_enums.dart';
import 'user_info_page.dart' as userInfo;

class MyPage extends StatefulWidget {
  final User user;

  MyPage(this.user);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with TickerProviderStateMixin {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
//  final GoogleSignIn _googleSignIn = GoogleSignIn();
//  final FirebaseAuth _auth = FirebaseAuth.instance;
  AnimationController _controller;
  Animation _firstAnimationMenu;
  Animation _lateAnimationMenu;
  AnimataionCommonStatus animataionCommonStatus;
  MyPageBloc _bloc;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _bloc = new MyPageBloc();
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));

    _firstAnimationMenu = Tween(begin: -1.0, end: 0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animataionCommonStatus = AnimataionCommonStatus.open;
        } else if (status == AnimationStatus.dismissed) {
          animataionCommonStatus = AnimataionCommonStatus.closed;
        } else {
          animataionCommonStatus = AnimataionCommonStatus.animating;
        }
      });
    _lateAnimationMenu = Tween(begin: -1.0, end: 0).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(0.3, 1.0, curve: Curves.fastOutSlowIn)));

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print("onMessage: $message");
        handleMessage(message);
      },
      onLaunch: (Map<String, dynamic> message) {
        print("onLaunch: $message");
        handleMessage(message);
      },
      onResume: (Map<String, dynamic> message) {
        print("onResume: $message");
        handleMessage(message);
      },
    );
    firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    updateFcmToken();
  }

  @override
  void didChangeDependencies() {
    print('dependencies changed');
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(MyPage oldWidget) {
    print('update widget');
    super.didUpdateWidget(oldWidget);
  }

  void handleMessage(Map<String, dynamic> message) async {
    var type = getValueFromMapData(message, 'type');
    var fromId = getValueFromMapData(message, 'fromId');
    if (type == 'invite') {
      showInvitePopup(context, message);
    } else if (type == 'accept') {
      _bloc.getUserViaLoginId(fromId).then((user2) {
        var currentUser = widget.user;
        String gameId = '${currentUser.loginId}-$fromId';
        Navigator.of(context).pushReplacement(new MaterialPageRoute(
            builder: (context) => new Game(GameMode.friends, currentUser, user2,
                gameId, PLAYER_SEND_REQ_SCREEN)));
      });
    }
  }

  void showInvitePopup(BuildContext context, Map<String, dynamic> message) {
    print(context == null);

    Timer(Duration(milliseconds: 200), () {
      showDialog<bool>(
        context: context,
        builder: (_) => buildDialog(context, message),
      );
    });
  }

  Widget buildDialog(BuildContext context, Map<String, dynamic> message) {
    var fromName = getValueFromMapData(message, 'fromName');

    return AlertDialog(
      content: Text('$fromName invites you to play!'),
      actions: <Widget>[
        FlatButton(
          child: Text('Decline'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text('Play'),
          onPressed: () {
            accept(message);
          },
        ),
      ],
    );
  }

  void accept(Map<String, dynamic> message) async {
    String fromPushId = getValueFromMapData(message, 'fromPushId');
    String fromId = getValueFromMapData(message, 'fromId');
    User user = widget.user;
    var pushId = await SharedPreferencesUtils.getStringToPreferens(PUSH_ID)
        .then((pushId) {});
    var base = 'https://us-central1-caro-53f7d.cloudfunctions.net';
    String dataURL =
        '$base/resPlayReq?to=$fromPushId&fromPushId=$pushId&fromId=${user.loginId}&fromName=${user.firstname}&fromGender=${user.gender}&type=accept';
    print(dataURL);
    await http.get(dataURL);
    String gameId = '$fromId-${user.loginId}';
    _bloc.getUserViaLoginId(fromId).then((user2) {
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (context) => new Game(GameMode.friends, user, user2, gameId,
              PLAYER_RECEIVE_REQ_SCREEN)));
    });
  }

  void updateFcmToken() async {
    var pushId = await firebaseMessaging.getToken();
//    var listPushId =
        _bloc.getListPushId(widget.user.loginId).then((listPushId) {
      SharedPreferencesUtils.setStringToPreferens(PUSH_ID, pushId);
      if (!listPushId.contains(pushId)) {
        listPushId.add(pushId);
        FirebaseDatabase.instance
            .reference()
            .child(USER_PUSH_INFO)
            .child(widget.user.loginId)
            .set({PUSH_ID: listPushId});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    _controller.forward();
    var aiName2 = '${WordPair.random()} ${WordPair.random()}';
    var aiName1 = '${WordPair.random()}';
    var aiName = aiName2.length > 11 ? aiName1 : aiName2;
    Widget singleMode() => Transform(
          transform: Matrix4.translationValues(
              _firstAnimationMenu.value * width, 0, 0),
          child: ButtonTheme(
            minWidth: 200.0,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                onPressed: () {
                  print('print single mode');
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => Game(
                            GameMode.single,
                            widget.user,
                            User()
                              ..firstname = '$aiName'
                              ..loginId = '${aiName}Id'
                              ..email = '$aiName@gmail.com',
                            null,
                            null,
                          ),
                    ),
                  );
                },
                padding: EdgeInsets.all(12),
                color: Colors.lightBlueAccent,
                child:
                    Text('Single mode', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        );
    Widget playWithFriend() => Transform(
        transform: Matrix4.translationValues(
            _firstAnimationMenu.value * width, 0.0, 0.0),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: ButtonTheme(
            minWidth: 200.0,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              onPressed: () {
                print('play with friends');
                openFriendList();
              },
              padding: EdgeInsets.all(12),
              color: Colors.lightBlueAccent,
              child: Text('Play with friends',
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        ));
    Widget quit() => Transform(
        transform: Matrix4.translationValues(
            _lateAnimationMenu.value * width, 0.0, 0.0),
        child: ButtonTheme(
          minWidth: 200.0,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              onPressed: () {
                print('Quit');
                showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: Text('Quit Game'),
                        content: Text('Do you want to quit the game ?'),
                        actions: <Widget>[
                          FlatButton(
                            child: new Text('Cancel'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            child: new Text('Yes'),
                            onPressed: () {
                              exit(0);
                            },
                          )
                        ],
                      );
                    });
              },
              padding: EdgeInsets.all(12),
              color: Colors.lightBlueAccent,
              child: Text('Quit', style: TextStyle(color: Colors.white)),
            ),
          ),
        ));

    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'CARO GAME',
              style: TextStyle(fontFamily: 'indie flower'),
            ),
          ),
          drawer: myPageDrawer(),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              singleMode(),
              Container(
                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
              ),
              playWithFriend(),
              Container(
                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
              ),
              quit(),
              Container(
                margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
              )
            ],
          ),
        );
      },
    );
  }

  Widget myPageDrawer() {
    Size size = MediaQuery.of(context).size;
    String imageUrl = widget.user.gender == 1
        ? 'assets/images/male.png'
        : 'assets/images/female.png';
    return SizedBox(
      width: size.width * 3 / 4,
      child: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the Drawer if there isn't enough vertical
          // space to fit everything.
          elevation: 2,
          child: Column(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(widget.user.firstname),
                accountEmail: Text(widget.user.email),
                currentAccountPicture: Hero(
                  tag: USER_AVA_TAG,
                  child: CircleAvatar(
                    child: Image.asset(imageUrl),
                    backgroundColor: Colors.white,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.account_circle),
                title: Text('User\'s info'),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return userInfo.UserInfo(widget.user,imageUrl);
                  }));
                },
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: Text('Logout'),
                onTap: () {
                  Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: (context) {
                    removeUserInfo();
                    return Loginpage();
                  }));
                },
              ),
            ],
          )),
    );
  }

  void openFriendList() async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => UserList(
              widget.user,
              title: 'Friend list',
            )));
  }

  void removeUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(USER_PREFS_KEY);
  }
}
