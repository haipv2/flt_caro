import 'package:flt_caro/src/common/common.dart';
import 'package:flt_caro/src/models/tips.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'widgets/custom_flat_button.dart';

class TipsScreen extends StatefulWidget {
  final SharedPreferences prefs;

  TipsScreen({this.prefs});

  @override
  _TipsScreenState createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {
  @override
  Widget build(BuildContext context) {
    final List<Tips> tipsPage = [
      Tips(
        icon: Icons.account_box,
//        title: TranslatorLoader.translate(context).text("account"),
        title: 'Account',
        description: "Register account to play the game with your friends. ",
      ),
      Tips(
        icon: Icons.info_outline,
        title: "Your account",
        description: "Register account to play the game with your friends. ",
      ),
      Tips(
        icon: Icons.insert_emoticon,
        title: "Thanks a lot!!!",
        description: "Thanks for reading. Enjoin!!! ",
      ),
    ];
    return Scaffold(
      body: Swiper.children(
        autoplay: false,
        index: 0,
        loop: false,
        pagination: new SwiperPagination(
          margin: new EdgeInsets.fromLTRB(0, 0, 0, 40),
          builder: new DotSwiperPaginationBuilder(
              color: Colors.white30,
              activeColor: Colors.blueAccent,
              size: 6.5,
              activeSize: 8.0),
        ),
        control: SwiperControl(
          iconPrevious: null,
          iconNext: null,
        ),
        children: _getPages(context, tipsPage, widget.prefs),
      ),
    );
  }

  List<Widget> _getPages(
      BuildContext context, List<Tips> tipsPage, SharedPreferences prefs) {
    List<Widget> widgets = [];
    for (var page in tipsPage) {
      widgets.add(new Container(
        color: Colors.lime,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 70.0),
              child: Icon(
                page.icon,
                size: 125,
                color: Colors.blueAccent,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50, right: 50, left: 15),
              child: Text(
                page.title,
                softWrap: true,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.none,
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                    fontFamily: "OpenSans"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: page.extraWidget,
            )
          ],
        ),
      ));
    }
    widgets.add(Container(
//      color: Colors.lime,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.play_arrow,
              size: 250,
              color: Colors.indigoAccent,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 50.0, right: 15.0, left: 15.0),
              child: CustomFlatButton(
                  title: "LET'S PLAY",
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  textColor: Colors.black87,
                  onPressed: () {
                    setState(() {
                      prefs.setBool('seen', true);
                    });
                    Navigator.of(context).pushReplacementNamed(MYPAGE);
                  },
                  splashColor: Colors.black12,
                  borderColor: Colors.white,
                  borderWidth: 2,
                  color: Colors.orangeAccent),
            )
          ],
        ),
      ),
    ));
    return widgets;
  }
}
