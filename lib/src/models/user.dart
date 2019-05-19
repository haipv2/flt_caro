const USER_EMAIL='email';
const USER_FIRST_NAME='firstName';
const USER_LAST_NAME='lastName';
const USER_LOGIN_ID='loginId';
const USER_PASSWORD='password';
const USER_GENDER='gender';
const USER_ROLE='role';


class User {
  String _firstname;
  String _lastname;
  String _email;
  String _password;
  String _role;
  int _gender;
  String _loginId;

  int get gender => _gender;

  User();

  User.fromJson(Map<String, dynamic> json) {
    loginId = json[USER_LOGIN_ID];
    firstname = json[USER_FIRST_NAME];
    email = json[USER_EMAIL];
    lastname = json[USER_LAST_NAME];
    gender = json[USER_GENDER];
  }

  Map<String, dynamic> toJson() => {
        USER_LOGIN_ID: loginId,
        USER_EMAIL: email,
        USER_FIRST_NAME: firstname,
        USER_LAST_NAME: lastname,
        USER_GENDER: gender,
      };

  String get loginId => _loginId;

  set loginId(String value) {
    _loginId = value;
  }

  set gender(int value) {
    _gender = value;
  }

  String get firstname => _firstname;

  set firstname(String value) {
    _firstname = value;
  }

  String get lastname => _lastname;

  String get role => _role;

  set role(String value) {
    _role = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  set lastname(String value) {
    _lastname = value;
  }
}
