import 'package:flt_caro/src/blocs/signup_bloc.dart';
import 'package:flt_caro/src/common/common.dart';
import 'package:flt_caro/src/ui/login_page.dart';
import 'package:flt_caro/src/ui/widgets/custom_flat_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'my_page.dart';

class SignUp extends StatefulWidget {
  SignUp();

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController passwordConfirmController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController loginTextController = new TextEditingController();
  SignupBloc _signUpBloc;

  @override
  void initState() {
    _signUpBloc = SignupBloc();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _signUpBloc.dispose();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> scaffoldSignupKey =
      new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Widget fistName = StreamBuilder(
        stream: _signUpBloc.firstNameStream,
        builder: (context, snapshot) {
          return Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: TextField(
              autofocus: false,
              controller: firstNameController,
              onChanged: _signUpBloc.changeFirstName,
              decoration: InputDecoration(
                labelText: 'First Name',
                hintText: 'Enter first name',
                errorText: snapshot.error,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    )),
              ),
            ),
          );
        });
    Widget lastName = StreamBuilder(
        stream: _signUpBloc.lastNameStream,
        builder: (context, snapshot) {
          return Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: TextField(
              onChanged: _signUpBloc.changeLastName,
              autofocus: false,
              controller: lastNameController,
              decoration: InputDecoration(
                  labelText: 'Last Name',
                  hintText: 'Enter last name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(color: Colors.grey, width: 1))),
            ),
          );
        });

    Widget email = StreamBuilder(
        stream: _signUpBloc.userEmailStream,
        builder: (context, snapshot) {
          return Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: TextField(
              onChanged: _signUpBloc.changeEmail,
              autofocus: false,
              controller: emailController,
              decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter a valid email',
                  errorText: snapshot.error,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(color: Colors.grey, width: 1))),
            ),
          );
        });

    var password = StreamBuilder(
      stream: _signUpBloc.passwordStream,
      builder: (context, snapshot) {
        return Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: TextField(
            obscureText: true,
            autofocus: false,
            controller: passwordController,
            onChanged: _signUpBloc.changePass,
            decoration: InputDecoration(
                labelText: 'Pasword',
                hintText: 'Enter your password.',
                errorText: snapshot.error,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(color: Colors.grey, width: 1))),
          ),
        );
      },
    );

    var passwordConfirm = StreamBuilder(
      stream: _signUpBloc.passwordConfirmStream,
      builder: (context, snapshot) {
        return Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: TextField(
            onChanged: _signUpBloc.changePassConfirm,
            autofocus: false,
            obscureText: true,
            controller: passwordConfirmController,
            decoration: InputDecoration(
                labelText: 'Confirm password',
                errorText: snapshot.error,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(color: Colors.grey, width: 1))),
          ),
        );
      },
    );
    int _defaultGender = 1;
    var gender = StreamBuilder(
      stream: _signUpBloc.genderStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null)
          _defaultGender = snapshot.data;
        print(_defaultGender);

        return Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Gender:',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          'Male',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                        Radio(
                          value: 1,
                          groupValue: _defaultGender,
                          onChanged: _signUpBloc.changeGenderStream,
                        ),
                      ],
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          'Female',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                        Radio(
                          value: 0,
                          groupValue: _defaultGender,
                          onChanged: _signUpBloc.changeGenderStream,
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ));
      },
    );

    Widget registerButton() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder(
              stream: _signUpBloc.registerStream,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) =>
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomFlatButton(
                      title: "Register",
                      fontSize: 15,
                      onPressed: (snapshot.hasData && snapshot.data == true)
                          ? () {
                              _doRegister();
                            }
                          : null,
                      fontWeight: FontWeight.w400,
                      textColor: (snapshot.hasData && snapshot.data == true)
                          ? Colors.black
                          : Colors.grey,
                      splashColor: Colors.black12,
                      borderColor: Colors.grey,
                      borderWidth: 0,
                      color: (snapshot.hasData && snapshot.data == true)
                          ? Colors.orange
                          : Colors.grey,
                    ),
                  ),
            ),
            CustomFlatButton(
              title: "Reset",
              fontSize: 15,
              fontWeight: FontWeight.w100,
              textColor: Colors.white,
              onPressed: () {
                resetSignupForm();
//                      _signUpBloc.registerStream;
              },
              splashColor: Colors.black12,
              borderColor: Colors.grey,
              borderWidth: 0,
              color: Colors.grey,
            ),
          ],
        );

    var registerByOtherWay = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
          child: InkWell(
            onTap: _pressFacebookSignup,
            child: Text(
              "Facebook Login",
              style: TextStyle(
                  color: Color.fromRGBO(59, 89, 152, 1.0),
                  fontWeight: FontWeight.w300,
                  fontSize: 15,
                  decoration: TextDecoration.underline),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 1.0),
          child: Text('OR',
              style: TextStyle(
                color: Colors.grey,
              )),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
          child: InkWell(
            onTap: _pressGoogleSignup,
            child: Text(
              "Google login",
              style: TextStyle(
                  color: Color.fromRGBO(59, 89, 152, 1.0),
                  fontWeight: FontWeight.w300,
                  fontSize: 15,
                  decoration: TextDecoration.underline),
            ),
          ),
        ),
      ],
    );
    return Scaffold(
      key: scaffoldSignupKey,
      appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text('Register'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Loginpage()));
            },
          )),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              height: 5,
            ),
            Container(
              margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
            ),
            fistName,
            Container(
              margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
            ),
            lastName,
            Container(
              margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
            ),
            loginId(),
            Container(
              margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
            ),
            email,
            Container(
              margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
            ),
            password,
            Container(
              margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
            ),
            passwordConfirm,
            Container(
              margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
            ),
            gender,
            Container(
              margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
            ),
            registerButton(),
            Container(
              margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
            ),
            registerByOtherWay,
          ],
        ),
      ),
    );
  }

  void _pressFacebookSignup({BuildContext context}) {
    print('facebook login');
  }

  void _pressGoogleSignup({BuildContext context}) {
    print('BEGIN: google login');
  }

  void _doRegister() async {
    _signUpBloc.register().then((user) {
      if (user == null) {
        SnackBar snackbar = SnackBar(
          content: Text('Email is already used. Input another email.'),
          duration: Duration(seconds: 2),
        );
        scaffoldSignupKey.currentState.showSnackBar(snackbar);
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyPage(user)));
      }
    });

    print('end _doRegister');
  }

  void showErrorMsg() {
    final snackbar =
        SnackBar(content: Text(ERR_MSG), duration: Duration(seconds: 3));
    Scaffold.of(context).showSnackBar(snackbar);
  }

  void resetSignupForm() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    passwordConfirmController.clear();
    passwordController.clear();
    loginTextController.clear();
  }

  Widget loginId() => StreamBuilder(
      stream: _signUpBloc.loginStream,
      builder: (context, snapshot) {
        return Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: TextField(
            onChanged: _signUpBloc.changeLoginStream,
            autofocus: false,
            controller: loginTextController,
            decoration: InputDecoration(
                labelText: 'Login',
                hintText: 'Login Id is used to play.',
                errorText: snapshot.error,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(color: Colors.grey, width: 1))),
          ),
        );
      });
}
