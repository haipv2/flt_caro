class ValidatorUtils {
  ///
  /// Check valid length
  ///
  static bool checkLength(String s, int maxLength, int minLength) {
    if (s == null ||
        s.length == 0 ||
        s.length > maxLength ||
        s.length < minLength) {
      return false;
    }
    return true;
  }

  ///
  /// Check valid string
  static bool validString(String s) {
    RegExp exp = new RegExp(r"(\w+)");
    return exp.hasMatch(s);
  }

  ///
  /// validate email
  ///
  static bool validEmail(String email) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(email);
  }
}
