class Utils{
  //#region Creating Singleton class
  Utils._internal();
  static final _utils = Utils._internal();
  factory Utils() => _utils;
  //# endregion

  static bool isEmailFormatValid(String email){
    String validEmailPattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[\w-]+$';
    RegExp regExp = RegExp(validEmailPattern);
    return regExp.hasMatch(email);
  }

  static bool isPasswordFormatValid(String password){
    return password.length >= 8;
  }

  static String userNameFromEmail(String email){
    return email.substring(0, email.indexOf('@'));
  }
}

enum ProcessStatus { idle, processing, successful, unsuccessful }