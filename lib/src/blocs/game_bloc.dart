
import 'package:flt_caro/src/models/user.dart';
import 'package:flt_caro/src/resources/repository.dart';

class GameBloc{
  final _repository = Repository();
  User getUserViaLoginId(String loginId, User player)  {
    User user = _repository.getUserViaLoginId(loginId);
    return user;


  }
}