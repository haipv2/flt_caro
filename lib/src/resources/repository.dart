import 'package:ticcar5/src/models/user.dart';
import 'package:ticcar5/src/models/user_push.dart';
import 'package:ticcar5/src/resources/firestore_provider.dart';

class Repository {
  final _firestoreProvider = FirestoreProvider();

  Future<User> registerUser(User user) async {
    var result = await _firestoreProvider.registerUser(user);
    return result;
  }

  Future<User> authenticateUser(String loginId, String password) async {
    var result = _firestoreProvider.authenticateUser(loginId, password);
    return result;
  }

  Future<void> registerUserPushInfo(UserPushInfo userPushInfo) async {
    var result = await _firestoreProvider.registerUserPushInfo(userPushInfo);
    return result;
  }

  Future<List<dynamic>> getListPushIdViaLoginId(String loginId) async{
    var result =await _firestoreProvider.getListPushIdViaLoginId(loginId);
    return result;
  }

  Future<User> getUserViaLoginId(String loginId) async{
    User result =await _firestoreProvider.getUserByLogin(loginId);

    return result;
  }

  Future<List<User>> getAllUser() async{
    var result = await _firestoreProvider.getAllUser();
    return result;
  }

  Future<List<User>>  getAllUserExceptLoginId(String currentLoginId) async{
    var result = await _firestoreProvider.getAllUserExceptLoginId(currentLoginId);
    return result;
  }

  Future<void> playGameWithFriend(String gameId, activePlayer) async{
    await _firestoreProvider.playGameWithFriend(gameId, activePlayer);
  }

  Future<void> cleanGame(String gameId) async {
    await _firestoreProvider.cleanGame(gameId);
  }

}
