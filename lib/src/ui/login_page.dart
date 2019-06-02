import 'package:ticcar5/src/blocs/login_bloc.dart';
import 'package:ticcar5/src/blocs/login_bloc_provider.dart';
import 'package:ticcar5/src/ui/signup_page.dart';
import 'package:ticcar5/src/utils/shared_preferences_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'my_page.dart';

class Loginpage extends StatefulWidget {
  @override
  _LoginpageState createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  TextEditingController loginIdTextController = new TextEditingController();
  TextEditingController passController = new TextEditingController();

  LoginBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = LoginBlocProvider.of(context);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var imageLogin = Container(
      width: 150,
      height: 150,
      child: Image.asset("assets/images/login.png"),
      decoration: BoxDecoration(shape: BoxShape.circle),
    );
    var textLogin = Text('Login Page');
    var emailTextField = StreamBuilder(
      stream: _bloc.loginIdStream,
      builder: (context, snapshot) {
        return Padding(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: TextField(
            autofocus: false,
            controller: loginIdTextController,
            onChanged: _bloc.loginIdStreamChange,
            decoration: InputDecoration(
                labelText: 'Login ID',
                prefixIcon: Icon(Icons.account_circle),
                errorText: snapshot.error,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(color: Colors.grey, width: 1))),
          ),
        );
      },
    );

    var passwordField = StreamBuilder(
      stream: _bloc.passwordStream,
      builder: (context, snapshot) {
        return Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: TextField(
            autofocus: false,
            controller: passController,
            obscureText: true,
            onChanged: _bloc.passwordStreamChange,
            decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
                errorText: snapshot.error,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(color: Colors.grey, width: 1))),
          ),
        );
      },
    );

    Widget loginButton(context) => StreamBuilder(
          stream: _bloc.loginStream,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot == null || !snapshot.hasData || snapshot.hasError) {
              return _processLogin(context);
            } else {
              return CircularProgressIndicator();
            }
          },
        );
    Widget registerUser() => Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RichText(
                text: TextSpan(
                    text: 'New user? ',
                    style: TextStyle(color: Colors.black),
                    recognizer: TapGestureRecognizer()..onTap = () {},
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            signUpUser();
                          },
                        text: 'Sign up',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ]),
              ),
//              Padding(
//                padding: const EdgeInsets.only(right: 10),
//                child: GestureDetector(
//                  onTap: _forgotPassword,
//                  child: Text(
//                    'Forgot password ?',
//                    style: TextStyle(
//                        color: Colors.blue, fontWeight: FontWeight.bold),
//                  ),
//                ),
//              )
            ],
          ),
        );
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            imageLogin,
            Container(
              margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
            ),
            textLogin,
            Container(
              margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
            ),
            emailTextField,
            Container(
              margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
            ),
            passwordField,
            Container(
              margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
            ),
            loginButton(context),
            Container(margin: EdgeInsets.fromLTRB(10, 20, 10, 0)),
            registerUser(),
          ],
        ),
      ),
    );
  }

  void signUpUser() {
    print('signup user');
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SignUp()));
  }

  void _authenticate(context) {
    if (loginIdTextController.value.text.isEmpty &&
        passController.value.text.isEmpty) {
      SnackBar snackbar = SnackBar(
        content: Text('Enter correctly loginId and password'),
        duration: Duration(seconds: 3),
      );
      Scaffold.of(context).showSnackBar(snackbar);
      return;
    }
    _bloc.authenticateUser().then((user) {
      if (user == null) {
        SnackBar snackbar = SnackBar(
          content: Text('LoginId or password is not corrected'),
          duration: Duration(seconds: 3),
        );
        Scaffold.of(context).showSnackBar(snackbar);
      } else {
        _bloc.doLoginStream(true);
        SharedPreferencesUtils.saveUserToPreferences(user);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MyPage(user)));
      }
    }).catchError((error) {
      SnackBar snackbar = SnackBar(
        content: Text(error),
        duration: Duration(seconds: 3),
      );
      Scaffold.of(context).showSnackBar(snackbar);
    });
  }

  ///
  /// process login
  ///
  Widget _processLogin(context) {
    return RaisedButton(
      child: Text('Login'),
      textColor: Colors.white,
      color: Colors.blue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onPressed: () {
        _authenticate(context);
      },
    );
  }
}
