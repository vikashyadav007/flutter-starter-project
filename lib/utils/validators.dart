import 'package:fuel_pro_360/utils/email_validator.dart';

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

  static String? validateIndent(String? value) {
    if (value!.isEmpty) {
      return "Enter Indent Number";
    }

    return null;
  }

  static String? validateAmount(String? value) {
    if (value!.isEmpty) {
      return "Enter Amount";
    }

    return null;
  }

  static String? validateQuantity(String? value) {
    if (value!.isEmpty) {
      return "Enter Quantity";
    }

    return null;
  }
}
