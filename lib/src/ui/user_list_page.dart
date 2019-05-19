import 'package:firebase_database/firebase_database.dart';
import 'package:flt_caro/src/blocs/user_push_bloc.dart';
import 'package:flt_caro/src/common/common.dart';
import 'package:flt_caro/src/models/user.dart';
import 'package:flt_caro/src/utils/shared_preferences_utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserList extends StatefulWidget {
  final String title;
  User currentUser;

  UserList(this.currentUser, {Key key, this.title}) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List<User> _users = List<User>();
  UserPushBloc _userPushBloc;

  @override
  void initState() {
    fetchUsers(widget.currentUser.loginId);
    _userPushBloc = new UserPushBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: ListView.separated(
            separatorBuilder: (context, index) => Divider(
                  color: Colors.black,
                ),
            itemCount: _users.length,
            itemBuilder: (context, index) => buildListRow(context, index)));
  }

  Widget buildListRow(BuildContext context, int index) => InkWell(
        onTap: () {
          Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(
                  'Send a challenge request to ${_users[index].firstname}')));
          challenge(_users[index]);
        },
        child: ListTile(
          leading: _users[index].gender == 0
              ? Image.asset('assets/images/female.png')
              : Image.asset('assets/images/male.png'),
          title: Text('${_users[index].firstname}${_users[index].lastname}'),
        ),
      );

  void fetchUsers(String currentLoginId) async {
    var snapshot =
        await FirebaseDatabase.instance.reference().child(USERS).once();

    Map<String, dynamic> users = snapshot.value.cast<String, dynamic>();
    users.forEach((loginId, userMap) {
      if (currentLoginId == loginId) return;
      User user = parseUser(loginId, userMap);
      if (user != null) {
        setState(() {
          _users.add(user);
        });
      }
    });
  }

  User parseUser(String loginId, Map<dynamic, dynamic> user) {
    String firstname, email, lastname;
    int gender;
    user.forEach((key, value) {
      if (key == USER_EMAIL) {
        email = value as String;
      } else if (key == USER_FIRST_NAME) {
        firstname = value as String;
      } else if (key == USER_LAST_NAME) {
        lastname = value as String;
      } else if (key == USER_GENDER) {
        gender = int.parse(value);
      }
    });

    return User()
      ..loginId = loginId
      ..firstname = firstname
      ..lastname = lastname
      ..email = email
      ..gender = gender;
  }

  challenge(User user) async {
    var pushIdFrom = await SharedPreferencesUtils.getStringToPreferens(PUSH_ID);

    List<dynamic> pushIds =
        await _userPushBloc.getListPushIdViaLoginId(user.loginId);

    var username = user.firstname;
    var friendsLoginId = user.firstname;
    var base = 'https://us-central1-caro-53f7d.cloudfunctions.net';
    var player1Items = widget.currentUser.loginId;

    pushIds.forEach((item) {
      String dataURL =
          '$base/sendNotification2?to=${item.toString()}&fromPushId=$pushIdFrom&fromId=${player1Items}&fromName=${widget.currentUser.firstname}&type=invite';
      print(dataURL);
      String gameId = '${player1Items}-${friendsLoginId}';
      FirebaseDatabase.instance
          .reference()
          .child(GAME_TBL)
          .child(gameId)
          .set(null);
      http.get(dataURL);
    });
  }
}
