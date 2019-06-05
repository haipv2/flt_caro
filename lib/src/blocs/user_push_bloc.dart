import 'package:ticcar5/src/models/user.dart';
import 'package:ticcar5/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class UserPushBloc {

  final _loadingStreamController = BehaviorSubject<bool>();

  final _repository = Repository();

  //Stream
  Observable<bool> get loadingStream => _loadingStreamController.stream;

  // input
  Function(bool) get loadingStreamChange => _loadingStreamController.sink.add;

  void dispose() async{
    await _loadingStreamController.drain();
    _loadingStreamController.close();
  }

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
