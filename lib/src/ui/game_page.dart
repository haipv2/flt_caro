import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ticcar5/src/blocs/game_bloc.dart';
import 'package:ticcar5/src/common/common.dart';
import 'package:ticcar5/src/models/user.dart';

import '../common/game_enums.dart';
import 'fighting_bar.dart';
import 'game_dialog_animation.dart';
import 'game_dialog_loser.dart';
import 'game_dialog_surrender.dart';
import 'game_dialog_surrender_single.dart';
import 'game_dialog_winner.dart';
import 'game_item.dart';
import 'game_item_animation.dart';
import 'my_page.dart';
import 'user_list_page.dart';

class Game extends StatefulWidget {
  User player1;
  GameMode gameMode;

  User player2;
  String player1LoginId;
  String player2LoginId;
  String gameId;
  String type;

  Game(this.gameMode, this.player1, this.player2, this.gameId, this.type);

  Game.fromLoginId(GameMode gameMode, User player1, String player2LoginId) {
    this.player1 = player1;
    print(player2);
  }

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> with TickerProviderStateMixin {
  List<GameItemAnimation> itemlist;
  List<int> player1List;
  List<int> player2List;
  var activePlayer;
  int player1Score = 0;
  int player2Score = 0;
  AnimationController _fightingController;
  Animation<double> _fightingAnimation;
  Animation<double> _itemAnimation;
  AnimationController _dialogController;
  Animation<double> _dialogAnimation;

  GameBloc _bloc;

  double _opacityTurn;

  @override
  void dispose() {
    _fightingController.dispose();
    _dialogController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    _dialogController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    _dialogAnimation = Tween(begin: -1.0, end: 0.0).animate(
        CurvedAnimation(parent: _dialogController, curve: Curves.elasticOut))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
//            _dialogController.reset();
        }
      });
    _bloc = new GameBloc();
    if (widget.gameMode == GameMode.friends) {
      FirebaseDatabase.instance
          .reference()
          .child(GAME_TBL)
          .child(widget.gameId)
          .onChildAdded
          .listen((Event event) {
        String key = event.snapshot.key;
        _dialogController.forward();
        print('----------$key');
        if (key == SURRENDER) {
          String titleSurrenderDialog = 'OPPS!!';
          String contentSurrenderDlg =
              'You\'re so powerful. Your friend already surrendered.';
          var value = event.snapshot.value;
          User surrenderer = User.fromJson(json.decode(value));
          if (widget.player1.loginId != surrenderer.loginId) {
            showDialog(
                context: context,
                builder: (_) {
                  return GameDialogAnimate(
                    animation: _dialogAnimation,
                    child: GameDialogSurrender(
                        titleSurrenderDialog, contentSurrenderDlg, () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => MyPage(widget.player1)));
                    }, "Quit"),
                  );
                });
          }
        } else if (key == WINNER) {
          String contentDialogLoser = 'Let\'s invite your friend to play again';
          var value = event.snapshot.value;
          User loser = User.fromJson(json.decode(value));
          var titleDialogLoser = "OPPS!!! You losed ";

          if (widget.player1.loginId == loser.loginId) {
            if (mounted) {
              setState(() {
                if (loser.loginId == widget.player1.loginId) {
                  player2Score += 1;
                } else {
                  player1Score += 1;
                }
              });
            }

            showDialog(
                context: context,
                builder: (_) {
                  return GameDialogAnimate(
                    animation: _dialogAnimation,
                    child: GameDialogLoser(
                      loser,
                      titleDialogLoser,
                      contentDialogLoser,
                      () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyPage(loser)),
                            (Route<dynamic> route) => false);
                      },
                      () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => UserList(
                                  loser,
                                  title: 'Friend list',
                                )));
                      },
                    ),
                  );
                });
          }
        } else if (key != NEXT_GAME) {
          loadGameItem(key, activePlayer);
          if (activePlayer == PLAYER_RECEIVE_REQ_SCREEN) {
            activePlayer = PLAYER_SEND_REQ_SCREEN;
          } else {
            activePlayer = PLAYER_RECEIVE_REQ_SCREEN;
          }

          if (widget.type == PLAYER_SEND_REQ_SCREEN) {
            if (activePlayer == PLAYER_SEND_REQ_SCREEN) {
              _opacityTurn = 1.0;
              player2List.add(int.parse(key));
            } else {
              _opacityTurn = 0.0;
            }
          } else {
            if (activePlayer == PLAYER_RECEIVE_REQ_SCREEN) {
              _opacityTurn = 1.0;
              player1List.add(int.parse(key));
            } else {
              _opacityTurn = 0.0;
            }
          }
        }
      });
    }
    _fightingController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 3500))
          ..addStatusListener(handlerFightingAnimation);

    _fightingAnimation = Tween(begin: 500.0, end: 1.0).animate(CurvedAnimation(
        parent: _fightingController,
        curve: Interval(0.0, 0.2, curve: Curves.elasticIn)));
    _itemAnimation = Tween(begin: 0.0, end: 300.0).animate(CurvedAnimation(
        parent: _fightingController,
        curve: Interval(0.2, 1, curve: Curves.fastOutSlowIn)))
      ..addStatusListener(handlerStatus);

    itemlist = doInit();
    if (GameMode.single == widget.gameMode) {
      doFristTurnSingle();
    } else {
      doFristTurnWithFriend();
    }
    _fightingController.forward();
    super.initState();
  }

  List<GameItemAnimation> doInit() {
    player1List = new List();
    player2List = new List();
    if (widget.gameMode == GameMode.single) {
      _opacityTurn = 1.0;
    }
    activePlayer = PLAYER_SEND_REQ_SCREEN;

    List<GameItemAnimation> gameItems = new List();
    for (var i = 0; i < SUM; i++) {
      gameItems.add(new GameItemAnimation(
        GameItem(id: i), _itemAnimation,
//        animation: _itemAnimation,
      ));
    }

    return gameItems;
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Widget playerInfo() => Container(
          color: Colors.orange,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildPlayer(widget.player1),
              _buildText('VS'),
              _buildPlayer(widget.player2),
            ],
          ),
        );

    return new Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        alignment: AlignmentDirectional.bottomEnd,
        child: Stack(
          children: <Widget>[
            new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                playerInfo(),
                Expanded(
                  flex: 6,
                  child: Stack(
                    children: <Widget>[
                      new GridView.builder(
                          padding: EdgeInsets.only(top: 5.0),
                          gridDelegate:
                              new SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: COLUMNS,
                                  crossAxisSpacing: 0.5,
                                  mainAxisSpacing: 0.5),
                          itemCount: itemlist.length,
                          itemBuilder: (context, i) => new SizedBox(
                                child: new RaisedButton(
                                  padding: const EdgeInsets.all(1.0),
                                  onPressed: itemlist[i].child.enabled
                                      ? () => playGame(i)
                                      : null,
//                                  child: itemlist[i],
                                  child: Text('$i'),
                                  color: itemlist[i].child.bg,
                                  disabledColor: itemlist[i].child.bg,
                                ),
                              )),
                    ],
                  ),
                ),
                surrenderSection(),
                scoreSection(),
                spaceSection(),
              ],
            ),
            FightingBar(
              animation: _fightingAnimation,
            ),
          ],
        ),
      ),
    );
  }

  void resetGame(String winner) {
    String contentDialogWinner = 'Next round will be started by your friend.';
    var winnerName;
    if (widget.type == PLAYER_SEND_REQ_SCREEN) {
      if (winner == PLAYER_SEND_REQ_SCREEN) {
        winnerName = widget.player1.firstname;
      } else {
        winnerName = widget.player2.firstname;
      }
    } else {
      print(winner);
      winnerName = widget.player1.firstname;
    }
    _dialogController.forward();
    var titleDialogWinner = "Player ${winnerName} Won";
    if (widget.gameMode == GameMode.friends) {
      pushToLoser(winner);
      showDialog(
          context: context,
          builder: (_) {
            return GameDialogAnimate(
                child: GameDialogWinner(titleDialogWinner, contentDialogWinner,
                    () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => MyPage(widget.player1)));
                }, "Quit"),
                animation: _dialogAnimation);
          });
    } else {
      setState(() {
        itemlist = doInit();
        doFristTurnSingle();
      });
    }
  }

  void playGame(int cellNumber) {
    print('User click: $activePlayer . Cell number: $cellNumber');
    if (widget.gameMode == GameMode.friends) {
      if (widget.type == PLAYER_SEND_REQ_SCREEN) {
        print('Press from send req screen');

        if (activePlayer == PLAYER_RECEIVE_REQ_SCREEN) {
          SnackBar snackbar = SnackBar(
            content: Text('Please wait until your\'s turn. '),
            duration: Duration(milliseconds: 1000),
          );
          _scaffoldKey.currentState?.showSnackBar(snackbar);
          return;
        }
      } else {
        print('Press from receiver screen');
        if (activePlayer == PLAYER_SEND_REQ_SCREEN) {
          SnackBar snackbar = SnackBar(
            content: Text('Please wait until your\'s turn. '),
            duration: Duration(milliseconds: 1000),
          );
          _scaffoldKey.currentState?.showSnackBar(snackbar);
          return;
        }
      }
    }

    setState(() {
      var imageUrl = 'assets/images/$activePlayer.gif';
      var newGameItem = GameItem(
        id: cellNumber,
        image: Image.asset(imageUrl),
        enabled: false,
      );
      var newGameItemAnimation = [
        GameItemAnimation(newGameItem, _itemAnimation)
      ];

      if (widget.gameMode == GameMode.friends) {
        FirebaseDatabase.instance
            .reference()
            .child(GAME_TBL)
            .child(widget.gameId)
            .child('$cellNumber')
            .set(activePlayer);
      }

      if (activePlayer == PLAYER_SEND_REQ_SCREEN) {
        itemlist.replaceRange(cellNumber, cellNumber + 1, newGameItemAnimation);
        player1List.add(cellNumber);
        if (widget.gameMode == GameMode.single) {
          activePlayer = PLAYER_RECEIVE_REQ_SCREEN;
        }
      } else {
        itemlist.replaceRange(cellNumber, cellNumber + 1, newGameItemAnimation);
        player2List.add(cellNumber);
        if (widget.gameMode == GameMode.single) {
          activePlayer = PLAYER_SEND_REQ_SCREEN;
        }
      }
      String winner;
      if (player1List.length > 4 || player2List.length > 4) {
        winner = checkWinner(cellNumber);
      }
      if (winner != null) {
        resetGame(winner);
        return;
      }
      if (widget.gameMode == GameMode.single) {
        int timeForAi = 50 + Random().nextInt(250);
        print('Time for AI: $timeForAi');
        Timer(Duration(milliseconds: timeForAi), () {
          activePlayer == PLAYER_RECEIVE_REQ_SCREEN
              ? autoPlay(cellNumber)
              : null;
        });
//        }
      }
    });
  }

  String checkWinner(id) {
    String winner;
    player1List.sort((i1, i2) => i1 - i2);
    player2List.sort((i1, i2) => i1 - i2);

    //check user 1 win
    if (widget.gameMode == GameMode.friends) {
      List tmpList = [];
      if (activePlayer == PLAYER_RECEIVE_REQ_SCREEN) {
        winner = doReferee(player2List, activePlayer, id);
      } else {
        //check user 2 win
        winner = doReferee(player1List, activePlayer, id);
      }
    } else if (widget.gameMode == GameMode.single) {
      if (activePlayer == PLAYER_RECEIVE_REQ_SCREEN) {
        winner = doReferee(player1List, activePlayer, id);
      } else {
        //check user 2 win
        winner = doReferee(player2List, activePlayer, id);
      }
    }

    if (winner != null) {
      setState(() {
        if (widget.gameMode == GameMode.single) {
          if (winner == PLAYER_SEND_REQ_SCREEN) {
            player2Score += 1;
          } else {
            player1Score += 1;
          }
        }
      });
      return winner;
    }
  }

  static const multiColRow = COLUMNS * ROWS;

  void autoPlay(int cellNumber) {
    var rowBefore = cellNumber - COLUMNS;
    var rowAfter = cellNumber + COLUMNS;
    List aroundCell = [];

    if (cellNumber == 0) {
      aroundCell.add(1);
      aroundCell.add(COLUMNS);
      aroundCell.add(COLUMNS + 1);
    } else if (cellNumber == COLUMNS - 1) {
      aroundCell.add(COLUMNS - 2);
      aroundCell.add(COLUMNS * 2);
      aroundCell.add(COLUMNS * 2 - 1);
    } else if (cellNumber == multiColRow - COLUMNS) {
      aroundCell.add(cellNumber - COLUMNS);
      aroundCell.add(cellNumber + 1);
      aroundCell.add(cellNumber - COLUMNS + 1);
    } else if (cellNumber == multiColRow - 1) {
      aroundCell.add(multiColRow - COLUMNS - 1);
      aroundCell.add(multiColRow - 1);
      aroundCell.add(multiColRow - 1);
    } else if (cellNumber % COLUMNS == 0) {
      aroundCell.add(rowBefore);
      aroundCell.add(rowBefore + 1);
      aroundCell.add(cellNumber + 1);
      aroundCell.add(rowAfter);
      aroundCell.add(rowAfter + 1);
    } else if (0 < cellNumber && cellNumber < COLUMNS - 1) {
      aroundCell.add(cellNumber - 1);
      aroundCell.add(cellNumber + 1);
      aroundCell.add(rowAfter);
      aroundCell.add(rowAfter - 1);
      aroundCell.add(rowAfter + 1);
    } else if (multiColRow - COLUMNS < cellNumber &&
        cellNumber < multiColRow - 1) {
      aroundCell.add(cellNumber - 1);
      aroundCell.add(cellNumber + 1);
      aroundCell.add(rowBefore);
      aroundCell.add(rowBefore - 1);
      aroundCell.add(rowBefore + 1);
    } else if ((cellNumber + 1) % COLUMNS == 0) {
      aroundCell.add(rowBefore);
      aroundCell.add(rowBefore - 1);
      aroundCell.add(cellNumber - 1);
      aroundCell.add(rowAfter);
      aroundCell.add(rowAfter - 1);
    } else {
      aroundCell.add(rowAfter - 1);
      aroundCell.add(rowAfter);
      aroundCell.add(rowAfter + 1);
      aroundCell.add(cellNumber - 1);
      aroundCell.add(cellNumber + 1);
      aroundCell.add(rowBefore);
      aroundCell.add(rowBefore - 1);
      aroundCell.add(rowBefore + 1);
    }

    var tempList = List.from(aroundCell);
    var cellId;
    List<int> listExistPlayer1 = [];
    for (var cellId in tempList) {
      if (player1List.contains(cellId)) {
        aroundCell.remove(cellId);
        listExistPlayer1.add(cellId);
      }
      if (player2List.contains(cellId)) {
        aroundCell.remove(cellId);
      }
    }

    for (var existCellId in listExistPlayer1) {
      cellId = processNextTurn(cellNumber, existCellId);
    }
    if (player2List.contains(cellId) || player1List.contains(cellId)) {
      cellId = null;
    }

    if (cellId == null) {
      var r = new Random();
      cellId = aroundCell[r.nextInt(aroundCell.length)];
    }
    int i = itemlist.indexWhere((p) => p.child.id == cellId);
    _opacityTurn = 1.0;
    playGame(i);
  }

  /// detect winner
  String doReferee(List<int> players, String winner, int currentCell) {
    // check vertically
    for (var i = 0; i < players.length; i++) {
      var playerMinCell = players[i];
      var playerMinx4 = playerMinCell + COLUMNS * 4;
      var vertically = players.contains(playerMinCell + COLUMNS) &&
          players.contains(playerMinCell + COLUMNS * 2) &&
          players.contains(playerMinCell + COLUMNS * 3) &&
          players.contains(playerMinx4);
      if (vertically) {
        var boundLeftRight = player2List.contains(playerMinx4 + COLUMNS) &&
            playerMinx4 - COLUMNS > 0 &&
            player2List.contains(playerMinCell - COLUMNS);
        if (boundLeftRight) {
          return null;
        }
        return winner;
      }
      var horizontally = players.contains(playerMinCell + 1) &&
          players.contains(playerMinCell + 2) &&
          players.contains(playerMinCell + 3) &&
          players.contains(playerMinCell + 4);
      if (horizontally) {
        var boundLeftRight = player2List.contains(playerMinCell + 5) &&
            playerMinCell - 1 > 0 &&
            player2List.contains(playerMinCell - 1);
        if (boundLeftRight) {
          return null;
        }
        return winner;
      }
      var crossRight = players.contains(playerMinx4 + 4) &&
          players.contains(playerMinCell + COLUMNS * 3 + 3) &&
          players.contains(playerMinCell + COLUMNS * 2 + 2) &&
          players.contains(playerMinCell + COLUMNS + 1);
      if (crossRight) {
        var boundLeftRight = player2List.contains(playerMinx4 + COLUMNS + 5) &&
            playerMinCell - COLUMNS - 1 > 0 &&
            player2List.contains(playerMinCell - COLUMNS - 1);
        if (boundLeftRight) {
          return null;
        }
        return winner;
      }
      var crossLeft = players.contains(playerMinx4 - 4) &&
          players.contains(playerMinCell + COLUMNS * 3 - 3) &&
          players.contains(playerMinCell + COLUMNS * 2 - 2) &&
          players.contains(playerMinCell + COLUMNS - 1);
      if (crossLeft) {
        var boundLeftRight = player2List.contains(playerMinx4 + COLUMNS - 5) &&
            playerMinCell - COLUMNS - 1 > 0 &&
            player2List.contains(playerMinCell - COLUMNS + 1);
        if (boundLeftRight) {
          return null;
        }
        return winner;
      }
    }
    return null;
  }

  Column _buildPlayer(User player) {
    String imagePath = player.gender == 0
        ? 'assets/images/female.png'
        : 'assets/images/male.png';
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CircleAvatar(
          backgroundImage: AssetImage(imagePath),
          backgroundColor: Colors.white,
        ),
        Container(
          margin: const EdgeInsets.only(top: 1),
          child: Text(
            player.firstname,
            style: TextStyle(
              fontFamily: 'indie flower',
            ),
          ),
        )
      ],
    );
  }

  Text _buildText(String s) {
    return Text(s,
        style: TextStyle(
            color: Colors.red,
            fontSize: 30.0,
            fontWeight: FontWeight.w600,
            fontFamily: 'indie flower'));
  }

  void _backToMain() {
    _dialogController.forward();
    showDialog(
      context: context,
      builder: (context) {
        return GameDialogAnimate(
          animation: _dialogAnimation,
          child: GameDialogSurrenderSingle(
              'OPPS!!!', 'Do you surrender easily ?', () {
            Navigator.of(context).pop();
          }, () {
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (context) {
              if (widget.gameMode == GameMode.friends) {
                _bloc.cleanGame(widget.gameId);
                sendSurrenderReq();
              }
              return MyPage(widget.player1);
            }));
          }),
        );
      },
    );
  }

  static const firstCell = ((COLUMNS * (ROWS ~/ 2)) + (COLUMNS ~/ 2 - 1));

  void doFristTurnSingle() {
    playGame(firstCell);
  }

  Widget surrenderSection() => Expanded(
        flex: 1,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.deepOrange,
              border: Border(top: BorderSide(width: 1.0, color: Colors.grey))),
          child: Stack(
            children: <Widget>[
              Positioned(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 550),
                    opacity: _opacityTurn,
                    child: AutoSizeText(
                      '${widget.player1.firstname}\'s turn',
                      style: TextStyle(
                        fontFamily: 'indie flower',
                        fontSize: 23,
                      ),
                      maxLines: 2,
                    ),
                  ),
                ),
              ),
              Positioned(
                child: Align(
                  alignment: Alignment.topRight,
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 550),
                    opacity: _opacityTurn = _opacityTurn == 0.0 ? 1.0 : 0.0,
                    child: AutoSizeText(
                      '${widget.player2.firstname}\'s turn',
                      style: TextStyle(
                        fontFamily: 'indie flower',
                        fontSize: 23,
                      ),
                      maxLines: 2,
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onTap: _backToMain,
                      child: Image.asset(
                        SURRENDER_FLAG,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget scoreSection() {
    return Expanded(
      flex: 1,
      child:
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Expanded(
          flex: 6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${widget.player1.firstname}',
                style: TextStyle(
                  fontFamily: 'indie flower',
                  fontSize: 20,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text('${player1Score}',
                    style: TextStyle(
                      fontSize: 23,
                    )),
              )
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: Row(
              children: <Widget>[
                Container(
                    child: Center(
                        child: Text(
                  ':',
                  style: TextStyle(fontSize: 30),
                ))),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Row(
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Text(
                      '$player2Score',
                      style: TextStyle(fontSize: 23),
                      textAlign: TextAlign.left,
                    ),
                  )),
              AutoSizeText(
                '${widget.player2.firstname}',
                style: TextStyle(
                  fontFamily: 'indie flower',
                  fontSize: 20,
                ),
                maxLines: 2,
              ),
            ],
          ),
        )
      ]),
    );
  }

  void doFristTurnWithFriend() {
    activePlayer = PLAYER_RECEIVE_REQ_SCREEN;
    if (widget.type == PLAYER_SEND_REQ_SCREEN) {
      _opacityTurn = 1.0;
    } else {
      activePlayer = PLAYER_RECEIVE_REQ_SCREEN;
      _opacityTurn = 0.0;
    }

    if (widget.type == PLAYER_RECEIVE_REQ_SCREEN) {
      playGame(firstCell);
    }
  }

  handlerFightingAnimation(status) {
    if (status == AnimationStatus.completed) {}
  }

  @override
  void didChangeDependencies() {
    print('did change dependencies. Change dependencies $_opacityTurn');
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(Game oldWidget) {
    print('did update widget. Update $_opacityTurn');
    super.didUpdateWidget(oldWidget);
  }

  void handlerStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _fightingController.stop();
    }
  }

  void loadGameItem(String key, String player) {
    int cellNumber = int.parse(key);
    var imageUrl = 'assets/images/$player.gif';
    var newGameItem = GameItem(
      id: cellNumber,
      image: Image.asset(imageUrl),
      enabled: false,
    );
    var newGameItemAnimation = [GameItemAnimation(newGameItem, _itemAnimation)];
    if (mounted) {
      setState(() {
        itemlist.replaceRange(cellNumber, cellNumber + 1, newGameItemAnimation);
      });
    }
  }

  void pushToLoser(String winner) async {
    User loser;
    if (widget.type == PLAYER_SEND_REQ_SCREEN) {
      if (winner == PLAYER_SEND_REQ_SCREEN) {
        setState(() {
          player1Score += 1;
        });
        loser = widget.player2;
      } else {
        setState(() {
          player2Score += 1;
        });
        loser = widget.player1;
      }
    } else {
      if (winner == PLAYER_SEND_REQ_SCREEN) {
        setState(() {
          player2Score += 1;
        });
        loser = widget.player1;
      } else {
        loser = widget.player2;
        setState(() {
          player1Score += 1;
        });
      }
    }
    await FirebaseDatabase.instance
        .reference()
        .child(GAME_TBL)
        .child(widget.gameId)
        .child(WINNER)
        .set(json.encode(loser));
  }

  void pushNextGame() async {
    await FirebaseDatabase.instance
        .reference()
        .child(GAME_TBL)
        .child(widget.gameId)
        .child(NEXT_GAME)
        .set(true);
  }

  void sendSurrenderReq() async {
    if (widget.gameMode == GameMode.friends) {
      await FirebaseDatabase.instance
          .reference()
          .child(GAME_TBL)
          .child(widget.gameId)
          .child(SURRENDER)
          .set(json.encode(widget.player1));
    }
  }

  Widget spaceSection() {
    return Expanded(
      flex: 1,
      child: SizedBox(
        height: 5.0,
      ),
    );
  }

  int processNextTurn(int newCellNumber, int existCellId) {
    int result;
    List<int> maxVerticalList = [];
    List<int> maxHorizpmtalList = [];
    List<int> maxCrossRightList = [];
    List<int> maxCrossLeftList = [];

    //vertically
    var columnIndexVertical = newCellNumber % COLUMNS;
    int maxVertical =
        getMaxVertial(newCellNumber, columnIndexVertical, maxVerticalList);
    var columnIndexHorizontal = newCellNumber ~/ COLUMNS;
    int maxHorizontal = getMaxHorizontal(
        newCellNumber, columnIndexHorizontal, maxHorizpmtalList);
    int maxCrossRight = getMaxCrossRight(newCellNumber);
    int maxCrossLeft = getMaxCrossLeft(newCellNumber);
    List<int> player1Line = [
      maxVertical,
      maxHorizontal,
      maxCrossLeft,
      maxCrossRight
    ]..sort((a, b) => b.compareTo(a));
    for (int i in player1Line) {
      if (i == maxVertical) {
        if (checkBoundVerticalFree(maxVerticalList)) {
          result = buildNextVertialCell(maxVerticalList);
        } else if (checkBoundHorizontalFree(maxHorizpmtalList)) {
          result = buildNextHorizontalCell(maxVerticalList);
        }
      }
    }
    print(maxVertical);

//    if (newCellNumber % COLUMNS == 0 || ((newCellNumber + 1) % COLUMNS == 0)) {
//      newCellNumber = newCellNumber + 1;
//    } else if (newCellNumber < COLUMNS ||
//        (newCellNumber < multiColRow &&
//            newCellNumber > multiColRow - COLUMNS)) {
//      newCellNumber = newCellNumber + COLUMNS;
//    } else {
//      if (newCellNumber - existCellId == COLUMNS) {
//        result = newCellNumber + COLUMNS;
//      } else if (newCellNumber - existCellId == -COLUMNS) {
//        result = newCellNumber - COLUMNS;
//      } else if (newCellNumber - existCellId == COLUMNS - 1) {
//        result = newCellNumber + COLUMNS + 1;
//      } else if (newCellNumber - existCellId == COLUMNS + 1) {
//        result = newCellNumber + COLUMNS + 1;
//      } else if (newCellNumber - existCellId == -COLUMNS + 1) {
//        result = newCellNumber - COLUMNS + 1;
//      } else if (newCellNumber - existCellId == -COLUMNS - 1) {
//        result = newCellNumber - COLUMNS - 1;
//      } else if (newCellNumber - existCellId == 1) {
//        result = newCellNumber + 1;
//      } else if (newCellNumber - existCellId + 1 == 0) {
//        result = newCellNumber - 1;
//      }
//    }

    return result;
  }

  int getMaxVertial(
      int newCellNumber, int columnIndex, List<int> maxVerticalList) {
    int result = 0;
    for (columnIndex; columnIndex < multiColRow;) {
      if (player1List.contains(columnIndex)) {
        result += 1;
        maxVerticalList.add(columnIndex);
        columnIndex += columnIndex;
      }
    }
    return result;
  }

  int getMaxHorizontal(
      int newCellNumber, int columnIndex, List<int> maxHorizpmtalList) {
    int result = 0;
    for (columnIndex; columnIndex < columnIndex + COLUMNS - 1;) {
      if (player1List.contains(columnIndex)) {
        result += 1;
        maxHorizpmtalList.add(columnIndex);
        columnIndex++;
      }
    }
    return result;
  }

  int getMaxCrossRight(int newCellNumber) {}

  int getMaxCrossLeft(int newCellNumber) {}

  bool checkBoundVerticalFree(maxVerticalList) {
    if (maxVerticalList.length < 2) {
      return true;
    }
    if (maxVerticalList[0] > COLUMNS) {
      if (player2List.contains(maxVerticalList[0] - COLUMNS) &&
          player2List.contains(
              maxVerticalList[maxVerticalList.length - 1] + COLUMNS)) {
        return false;
      }
    } else {
      if (player2List
          .contains(maxVerticalList[maxVerticalList.length - 1] + COLUMNS)) {
        return false;
      }
    }
    if (maxVerticalList[maxVerticalList.length - 1] ~/ COLUMNS == COLUMNS) {
      if (player2List.contains(maxVerticalList[0] - COLUMNS)) {
        return false;
      }
    }
    return true;
  }

  int buildNextVertialCell(maxVertialList) {
    var r = new Random();
    return maxVertialList[r.nextInt(maxVertialList.length)];
  }

  bool checkBoundHorizontalFree(List<int> maxHorizpmtalList) {
    if (maxHorizpmtalList.length < 2) {
      return true;
    }
    if (maxHorizpmtalList[0] % COLUMNS == 0) {
      if (player2List
          .contains(maxHorizpmtalList[maxHorizpmtalList.length - 1] + 1)) {
        return false;
      }
    } else {
      if (player2List.contains(maxHorizpmtalList[0] - 1) &&
          player2List
              .contains(maxHorizpmtalList[maxHorizpmtalList.length - 1] + 1)) {
        return false;
      }
    }
    if (maxHorizpmtalList[maxHorizpmtalList.length - 1] % COLUMNS == 1) {
      if (player2List.contains(maxHorizpmtalList[0] - 1)){
        return false;
      }
    }
    return true;
  }

  int buildNextHorizontalCell(List<int> maxHorizontalList) {
    var r = new Random();
    return maxHorizontalList[r.nextInt(maxHorizontalList.length)];
  }
}
