import 'dart:async';

import 'package:flt_caro/src/models/user.dart';
import 'package:flt_caro/src/resources/repository.dart';
import 'package:flt_caro/src/utils/validator_utils.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginBloc {
  final _repository = Repository();
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  final _loginIdController = BehaviorSubject<String>();
  final _userPasswordController = BehaviorSubject<String>();
  final _loginStreamController = PublishSubject<bool>();
  final _imageStreamLoginController = BehaviorSubject<String>();

  StreamTransformer<String, String> _validateLoginId =
      StreamTransformer<String, String>.fromHandlers(
          handleData: (loginId, sink) {
    if (!ValidatorUtils.checkLength(loginId, 10, 3)) {
      sink.addError('Email is invalid.');
    } else {
      sink.add(loginId);
    }
  });

  StreamTransformer<String, String> _validPassword =
      StreamTransformer<String, String>.fromHandlers(
          handleData: (password, sink) {
    if (password.isEmpty) {
      sink.addError('Input password');
    } else {
      sink.add(password);
    }
  });

  void dispose() async {
    await _loginIdController.drain();
    _loginIdController?.close();
    await _userPasswordController.drain();
    _userPasswordController?.close();
    await _loginStreamController.drain();
    _loginStreamController?.close();
    await _imageStreamLoginController.drain();
    _imageStreamLoginController?.close();
  }

  //Stream
  Observable<String> get imageStream => _imageStreamLoginController.stream;

  Observable<String> get loginIdStream =>
      _loginIdController.stream.transform(_validateLoginId);

  Observable<String> get passwordStream =>
      _userPasswordController.stream.transform(_validPassword);

  Observable<bool> get loginStream => _loginStreamController.stream;

//  Observable<bool> get loginStream => Observable.combineLatest2(emailStream, passwordStream, (e,p) => true);

  Function(bool) get doLoginStream => _loginStreamController.sink.add;

  //add input
  Function(String) get loginIdStreamChange => _loginIdController.sink.add;

  Function(String) get passwordStreamChange => _userPasswordController.sink.add;

  Future<User> authenticateUser() {
    var loginId = _loginIdController.value;
    var password = _userPasswordController.value;
    return _repository.authenticateUser(loginId, password);
  }
}
