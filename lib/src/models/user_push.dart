const USER_PUSH_LOGIN_ID='loginId';
const USER_PUSH_PUSH_ID='pushId';

class UserPushInfo {
  String _loginId;
  List<String> _pushIds;

  UserPushInfo(this._loginId, this._pushIds);

  Map<String, dynamic> toJson() => {
        USER_PUSH_LOGIN_ID: loginId,
        USER_PUSH_PUSH_ID: pushIds,
      };

  UserPushInfo.fromJson(Map<String, dynamic> map) {
    loginId = map[USER_PUSH_LOGIN_ID];
    pushIds = map[USER_PUSH_PUSH_ID];
  }


  List<String> get pushIds => _pushIds;

  set pushIds(List<String> value) {
    _pushIds = value;
  }

  String get loginId => _loginId;

  set loginId(String value) {
    _loginId = value;
  }

}
