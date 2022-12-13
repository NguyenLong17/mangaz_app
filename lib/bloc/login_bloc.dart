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
      errorPassword = 'Tối thiểu 8 ký tự';
    } else {
      if (!password.contains(RegExp(r"[a-z]"))) {
        errorPassword = 'Tối thiểu 1 chữ cái viết thường';
      }
      if (!password.contains(RegExp(r"[A-Z]"))) {
        errorPassword = 'Tối thiểu 1 chữ cái viết hoa';
      }
      if (!password.contains(RegExp(r"[0-9]"))) {
        errorPassword = 'Tối thiểu 1 chữ số';
      }
    }
    return errorPassword;
  }

  void checkPhoneNumber(String phoneNumber) {
    errorPhone = '';

    if (phoneNumber.isEmpty) {
      errorPhone = 'Số điện thoại không được bỏ trống';
    } else if (!isPhone(phoneNumber)) {
      errorPhone = 'Số điện thoại không hợp lệr';
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
