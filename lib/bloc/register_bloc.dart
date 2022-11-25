import 'dart:async';

class RegisterBloc {
  final _registerStreamController = StreamController<bool>.broadcast();

  Stream<bool> get registerStream => _registerStreamController.stream;


  String errorName = '';

  String errorPhone = '';

  String errorPassword = '';
  bool showPassword = true;
  bool showPasswordIcon = true;

  String errorConfirmPassword = '';
  bool showConfirmPassword = true;
  bool showConfirmPasswordIcon = true;

  String errorDataOfBirth = '';

  String errorEmail = '';

  void checkName(String name) {
    if (name.length < 3) {
      errorName = 'Requires at least 3 characters';
      _registerStreamController.add(true);
    } else {
      if (name.contains(RegExp(r'^[a-zA-Z0-9]+$'))) {
        errorName = '';
        _registerStreamController.add(false);
      } else {
        errorName = 'Name cannot contain special characters';
        _registerStreamController.add(true);
      }
    }
  }

  void checkPhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty) {
      errorPhone = 'Phone number can not be left blank';
      _registerStreamController.add(true);
    } else if (!isPhone(phoneNumber)) {
      errorPhone = 'invalid phone number';
      _registerStreamController.add(true);
    } else {
      errorPhone = '';
      _registerStreamController.add(false);
    }
  }

  bool isPhone(String phoneNumber) {
    final regExp = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
    return regExp.hasMatch(phoneNumber);
  }

  void checkPassword(String password) {
    final error = isPasswordError(password);
    if (error.isEmpty) {
      _registerStreamController.add(true);
    } else {
      _registerStreamController.add(false);
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

  bool isPassword(String password) {
    final regExp = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
    return regExp.hasMatch(password);
  }

  void showTextFieldPassword() {
    showPassword = !showPassword;
    showPasswordIcon = !showPasswordIcon;
    _registerStreamController.add(showPassword);
    _registerStreamController.add(showPasswordIcon);
  }

  void checkConfirmPassword(String password, String confirmPassword) {
    if (password != confirmPassword) {
      errorConfirmPassword = 'Passwords are not the same';
      _registerStreamController.add(true);
    } else {
      errorConfirmPassword = '';
      _registerStreamController.add(false);
    }
  }

  void showTextFieldConfirmPassword() {
    showConfirmPassword = !showConfirmPassword;
    showConfirmPasswordIcon = !showConfirmPasswordIcon;
    _registerStreamController.add(showConfirmPassword);
    _registerStreamController.add(showConfirmPasswordIcon);
  }

  void checkDateOfBirth(String dateOfBirth) {
    if(dateOfBirth == '') {
      errorDataOfBirth = 'Choose your date of birth';
      _registerStreamController.add(true);
    } else {
      _registerStreamController.add(false);
    }
  }

  void checkEmail (String email) {
    if (email.isEmpty) {
      errorEmail = 'Email can not be left blank';
      _registerStreamController.add(true);
    } else if (!isEmail(email)) {
      errorEmail = 'invalid email';
      _registerStreamController.add(true);
    } else {
      errorEmail = '';
      _registerStreamController.add(false);
    }
  }

  bool isEmail(String email) {
    final regExp = RegExp( r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    return regExp.hasMatch(email);
  }





}
