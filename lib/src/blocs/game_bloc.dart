
import 'package:ticcar5/src/models/user.dart';
import 'package:ticcar5/src/resources/repository.dart';

class GameBloc{
  final _repository = Repository();
  Future<User> getUserViaLoginId(String loginId, User player)  async{
    User user = await _repository.getUserViaLoginId(loginId);
    return user;
  }

  Future<void> playGameWithFriend(String gameId, activePlayer) async{
    await _repository.playGameWithFriend(gameId, activePlayer);
  }

  Future<void> cleanGame(String gameId) async{
    await _repository.cleanGame(gameId);
  }

  Future<List<dynamic>> getListPushIdViaLoginId(String loginId) async{
    var result = await _repository.getListPushIdViaLoginId(loginId);
    return result;
  }

}