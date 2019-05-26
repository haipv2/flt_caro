import 'package:flt_caro/src/models/user.dart';
import 'package:flt_caro/src/resources/repository.dart';

class UserPushBloc {
  final _repository = Repository();

  Future<List<dynamic>> getListPushIdViaLoginId(String loginId) async{
    var result = await _repository.getListPushIdViaLoginId(loginId);
    return result;
  }

  Future<List<User>> getAllUser() async {
    var result = await _repository.getAllUser();
    return result;
  }
  Future<List<User>> getAllUserExceptLoginId(String currentLoginId) async {
    var result = await _repository.getAllUserExceptLoginId(currentLoginId);
    return result;
  }

}
