import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ticcar5/src/common/common.dart';
import 'package:ticcar5/src/models/user.dart';
import 'package:ticcar5/src/models/user_push.dart';
import 'package:ticcar5/src/resources/repository.dart';
import 'package:ticcar5/src/utils/shared_preferences_utils.dart';
import 'package:ticcar5/src/utils/validator_utils.dart';
import 'package:rxdart/rxdart.dart';

class SignupBloc extends Object {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final _repository = Repository();
  final _firstNameController = BehaviorSubject<String>();
  final _lastNameController = BehaviorSubject<String>();
  final _userEmailController = BehaviorSubject<String>();
  final _userPasswordController = BehaviorSubject<String>();
  final _confirmPasswordController = BehaviorSubject<String>();
  final _genderStreamController = BehaviorSubject<int>();
//  final _resetFormStreamController = PublishSubject();
  final _loginStreamController = BehaviorSubject<String>();

  String get email => _userEmailController.value;

  Observable<String> get loginStream => _loginStreamController.stream.transform(_validateLoginId);
  Function(String) get changeLoginStream => _loginStreamController.sink.add;

  final _validateLoginId =
      StreamTransformer<String,String>.fromHandlers(handleData: (loginId,sink){
  if (!ValidatorUtils.validString(loginId) ||
  !ValidatorUtils.checkLength(loginId, 10, 3)) {
  sink.addError('This is required and contain from 3-10 characters.');
  } else {
  sink.add(loginId);
  }
  });

  final _validateName =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (!ValidatorUtils.validString(name) ||
        !ValidatorUtils.checkLength(name, 10, 3)) {
      sink.addError('This is required and contain from 3-10 characters.');
    } else {
      sink.add(name);
    }
  });

  final _validatePass =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (!ValidatorUtils.validString(name) ||
        !ValidatorUtils.checkLength(name, 13, 6)) {
      sink.addError('This is required and contain from 6-12 characters.');
    } else {
      sink.add(name);
    }
  });

  final _validatePassConfirm = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password == null) {
      sink.addError('password is required');
    } else {
      sink.add(password);
    }
  });

  final _validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (!ValidatorUtils.validEmail(email)) {
      sink.addError('Email is invalid.');
    } else {
      sink.add(email);
    }
  });

  // Streams
  Observable<int> get genderStream => _genderStreamController.stream;

  Observable<String> get firstNameStream =>
      _firstNameController.stream.transform(_validateName);

  Observable<String> get lastNameStream =>
      _lastNameController.stream.transform(_validateName);

  Observable<String> get userEmailStream =>
      _userEmailController.stream.transform(_validateEmail);

  Observable<String> get passwordStream => _userPasswordController.stream
          .transform(_validatePass)
          .doOnData((String s) {
        if (0 != _confirmPasswordController.value.compareTo(s)) {
          _confirmPasswordController.sink.addError('Password does not match.');
        }
      });

  Observable<String> get passwordConfirmStream =>
      _confirmPasswordController.stream
          .transform(_validatePassConfirm)
          .doOnData((String c) {
        if (0 != _userPasswordController.value.compareTo(c)) {
          _confirmPasswordController.addError('Password does not match.');
        }
      });


  //change data
  Function(String) get changeFirstName => _firstNameController.sink.add;

  Function(String) get changeLastName => _lastNameController.sink.add;

  Function(String) get changeEmail => _userEmailController.sink.add;

  Function(String) get changePass => _userPasswordController.sink.add;

  Function(String) get changePassConfirm => _confirmPasswordController.sink.add;

  Function(int) get changeGenderStream => _genderStreamController.sink.add;

  //register button
  Stream<bool> get registerStream => Observable.combineLatest6(
      firstNameStream,
      lastNameStream,
      userEmailStream,
      loginStream,
      passwordStream,
      passwordConfirmStream,
      (firstName, lastname, email, login, pass, confirmPass) => true);

  void dispose() async {
    await _firstNameController.drain();
    _firstNameController?.close();
    _confirmPasswordController?.close();
    _lastNameController?.close();
    _userPasswordController?.close();
    _userEmailController?.close();
    _genderStreamController?.close();
    _loginStreamController?.close();
  }

  Future<User> register() async {

    User user = User();
    user.firstname = _firstNameController.value;
    user.lastname = _lastNameController.value;
    user.email = _userEmailController.value;
    user.password = _userPasswordController.value;
    user.gender = _genderStreamController.value == null ? 1: 0;
    user.loginId=_loginStreamController.value;
    var result = await _repository.registerUser(user);

    var pushId = await firebaseMessaging.getToken();

    UserPushInfo userPushInfo = UserPushInfo(user.loginId, [pushId]);
    await _repository.registerUserPushInfo(userPushInfo);
    SharedPreferencesUtils.saveUser(user);
    SharedPreferencesUtils.setString(PUSH_ID, pushId);

    return result;
  }

}
