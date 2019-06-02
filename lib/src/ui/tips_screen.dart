import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticcar5/src/common/common.dart';
import 'package:ticcar5/src/models/tips.dart';

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
        description:
            "Register account to play the game with your friends. They are simple steps and take you few seconds ^_^ ",
      ),
      Tips(
        icon: Icons.info_outline,
        title: "Game info",
        description:
            "\tPlayer who reach 5 sequent items first on a line first will be winner.Horizontally, vertically, crossly are accepted as long as you reach 5 sequent items first. You will be winner.\nThere are 2 modes: Single mode and Play with your friends.",
      ),
      Tips(
        icon: Icons.insert_emoticon,
        title: "Thanks a lot!!!",
        description: "Thanks for reading.\n Enjoin ^^!",
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
          iconPrevious: Icons.arrow_back,
          iconNext: Icons.arrow_forward,
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
            Column(children: <Widget>[
              Center(
                child: Text(
                  page.title,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.none,
                      fontSize: 40,
                      fontWeight: FontWeight.w300,
                      fontFamily: "OpenSans"),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                child: RichText(
                  text: TextSpan(
                    text: page.description,
                    style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.none,
                        fontSize: 25,
                        fontWeight: FontWeight.w300,
                        fontFamily: "OpenSans"),
                    children: <TextSpan>[
                    ],
                  ),
                ),

//                    page.description,
//                    softWrap: true,
//                    textAlign: TextAlign.left,
//                    style: TextStyle(
//                        color: Colors.white,
//                        decoration: TextDecoration.none,
//                        fontSize: 15,
//                        fontWeight: FontWeight.w300,
//                        fontFamily: "OpenSans"),
//                  ),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.all(10),
              child: page.extraWidget,
            )
          ],
        ),
      ));
    }
    widgets.add(Container(
      color: Colors.lime,
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
                    Navigator.of(context).pushReplacementNamed(LOGIN_PAGE);
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
