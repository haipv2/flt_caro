import 'package:flt_caro/src/resources/repository.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'login_bloc.dart';

class LoginBlocProvider extends InheritedWidget {
  final bloc = LoginBloc();

  LoginBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext context){
    return (context.inheritFromWidgetOfExactType(LoginBlocProvider) as LoginBlocProvider).bloc;
  }

}

