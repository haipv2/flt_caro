
import 'package:flt_caro/src/models/user.dart';
import 'package:flt_caro/src/resources/repository.dart';

class GameBloc{
  final _repository = Repository();
  Future<User> getUserViaLoginId(String loginId, User player)  async{
    User user = await _repository.getUserViaLoginId(loginId);
    return user;


  }
}