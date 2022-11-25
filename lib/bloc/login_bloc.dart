import 'dart:async';

class LoginBloc {

  final _loginSteamController = StreamController<bool>();

  Stream<bool> get loginStream => _loginSteamController.stream;

  String errorPassword = '';
  String errorPhone = '';

  bool isPhoneChecked = false;
  bool showPassword = true;
  bool showPasswordIcon = true;

  void checkPassword(String password) {
    final error = isPasswordError(password);
    if (error.isEmpty) {
      _loginSteamController.add(true);
    } else {
      _loginSteamController.add(false);
    }
  }

  String isPasswordError(String password) {
    errorPassword = '';
    if (password.length < 8) {
      errorPassword = 'Less than 8 characters';
    } else {
      if (!password.contains(RegExp(r"[a-z]"))) {
        errorPassword = 'Requires at least 1 lowercase letter';
      }
      if (!password.contains(RegExp(r"[A-Z]"))) {
        errorPassword = 'Requires at least 1 uppercase letter';
      }
      if (!password.contains(RegExp(r"[0-9]"))) {
        errorPassword = 'Need at least 1 number';
      }
    }
    return errorPassword;
  }

  void checkPhoneNumber(String phoneNumber) {
    errorPhone = '';

    if (phoneNumber.isEmpty) {
      errorPhone = 'Phone number can not be left blank';
    } else if (!isPhone(phoneNumber)) {
      errorPhone = 'invalid phone number';
    }
    if (errorPhone.isEmpty) {
      _loginSteamController.add(true);
    } else {
      _loginSteamController.add(false);
    }
  }

  bool isPhone(String phoneNumber) {
    final regExp = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
    return regExp.hasMatch(phoneNumber);
  }

  bool isPassword(String password) {
    final regExp = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
    return regExp.hasMatch(password);
  }
  void showTextFieldPassword() {
    showPassword = !showPassword;
    showPasswordIcon = !showPasswordIcon;
    _loginSteamController.add(showPassword);
    _loginSteamController.add(showPasswordIcon);
  }

}
