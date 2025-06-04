import 'package:starter_project/utils/email_validator.dart';

class Validators {
  static String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return 'Enter email address';
    }

    if (EmailValidator.validate(value)) {
      return null;
    }
    return 'Email is not valid';
  }

  static String? validatePassword(String? value) {
    if (value!.isEmpty) {
      return "Enter Password";
    }

    return null;
  }
}
