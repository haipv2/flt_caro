import 'package:flt_caro/src/models/user.dart';
import 'package:flt_caro/src/models/user_push.dart';
import 'package:flt_caro/src/resources/firestore_provider.dart';

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

  User getUserViaLoginId(String loginId) {
    var result = _firestoreProvider.getUserByLogin(loginId);
     print('object $result');

    return result as User ;
  }
}
