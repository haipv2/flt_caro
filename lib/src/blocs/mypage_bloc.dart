import 'package:ticcar5/src/models/user.dart';
import 'package:ticcar5/src/resources/repository.dart';

class MyPageBloc {
  final _repository = Repository();
  Future<User> getUserViaLoginId(String loginId) async {
    var user = await _repository.getUserViaLoginId(loginId);
    return user;
  }

  Future<List<dynamic>> getListPushId(String loginId) async{
    var listPushId = await _repository.getListPushIdViaLoginId(loginId);
    return listPushId;
  }
}