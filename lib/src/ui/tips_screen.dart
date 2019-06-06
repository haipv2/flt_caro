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
        child: Icon(Icons.account_box,size: 100,),
        title: 'Account',
        description:
            "Register an account to play game with your friends. Registing steps are simple and just take a few seconds. ^_^ ",
      ),
      Tips(
        child: Icon(Icons.info_outline,size: 100,),
        title: "Game info",
        description:
            "The player who manages to create an unbroken row of 5 symbles first wins the game. The row can be horizontal, vertical or diagonal.",
      ),
      Tips(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text('the last rule ', style: TextStyle(color: Colors.white, fontSize: 23),),
            SizedBox(height: 10,),
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                'assets/images/guide.jpg',
              ),
            ),
          ],
        ),
        title: "",
        description: "",
      ),
      Tips(
        child: Icon(Icons.insert_emoticon,size: 100,),
        title: "Thanks a lot!!!",
        description: "There are 2 modes: single mode or friend mode. Let's engjoy the game.",
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
        color: Colors.orange,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 70.0),
              child: page.child,
//              Icon(
//                page.child,
//                size: 125,
//                color: Colors.deepOrange,
//              ),
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
                    children: <TextSpan>[],
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
