import 'package:easy_localization/easy_localization.dart';

import '../widgets/phone_form_feild.dart';

class Validator {
  static String? defaultValidator(String? value) {
    if (value != null && value.trim().isEmpty) {
      return tr("error_filed_required");
    }
    return null;
  }

  static String? name(String? value) {
    if (value != null) {
      value = value.trim();
      if (value.isEmpty) {
        return tr("error_filed_required");
      }
    }
    return null;
  }

  static String? fastOrder(String? value) {
    if (value != null) {
      value = value.trim();
      if (value.isEmpty) {
        return tr("error_filed_required");
      }
      if (value.length < 3) {
        return tr("short_input_fast");
      }
    }
    return null;
  }

  static String? registerAddress(String? value) {
    if (value != null) {
      value = value.trim();
      if (value.isEmpty) {
        return tr("error_filed_required");
      }
      if (value.length < 4) {
        return tr("short_address");
      }
    }
    return null;
  }

  static String? text(String? value) {
    if (value != null) {
      value = value.trim();
      if (value.isEmpty) {
        return tr("error_filed_required");
      } else if (!RegExp('[a-zA-Z]').hasMatch(value)) {
        return tr("enter_correct_name");
      }
    }
    return null;
  }

  static String? defaultEmptyValidator(String? value) {
    return null;
  }

  static String? email(String? value) {
    if (value != null) {
      value = value.trim();
      if (value.isEmpty) {
        return tr("error_filed_required");
      } else if (!RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(value)) {
        return tr("error_email_regex");
      }
    } else {
      return tr("error_filed_required");
    }
    return null;
  }

  static String? password(String? value) {
    if (value != null) {
      value = value.trim();
      if (value.isEmpty) {
        return tr("error_filed_required");
      } else if (value.length < 8 ||
          !RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$")
              .hasMatch(value)) {
        return tr("error_password_validation");
      }
    }
    return null;
  }

  static String? confirmPassword(String? confirmPassword, String? password) {
    if (confirmPassword != null) {
      confirmPassword = confirmPassword.trim();
      if (confirmPassword.isEmpty) {
        return tr("error_filed_required");
      } else if (confirmPassword != password) {
        return tr("error_wrong_password_confirm");
      }
    } else {
      return tr("error_filed_required");
    }
    return null;
  }

  static String? numbers(String? value) {
    if (value != null) {
      value = value.trim();
      if (value.isEmpty) {
        return tr("error_filed_required");
      }
      if (value.startsWith("+")) {
        value = value.replaceFirst(r'+', "");
      }
      final number = int.tryParse(value);
      if (number == null) {
        return tr("error_wrong_input");
      }
    } else {
      return tr("error_filed_required");
    }
    return null;
  }

  static String? phone(String? value, PhoneModel model) {
    if (value != null) {
      value = value.trim();
      if (value.isEmpty) {
        return tr("error_filed_required");
      }
      if (!value.startsWith(model.startWith) || value.length != model.lenght) {
        return tr("must_start_with") +
            model.startWith +
            tr("and_constits_of") +
            model.lenght.toString() +
            tr("numbers");
      }
    }
    return null;
  }
  // static String? phone(String? value) {
  //   if (value != null) {
  //     value = value.trim();
  //     if (value.isEmpty) {
  //       return tr("error_filed_required");
  //     }
  //     if (value.startsWith("+9665") && value.length == 13) {
  //       value = value.replaceFirst(r'+', "");
  //     } else {
  //       return tr("error_wrong_phone");
  //     }
  //     final number = int.tryParse(value);
  //     if (number == null) {
  //       return tr("error_wrong_input");
  //     }
  //   } else {
  //     return tr("error_filed_required");
  //   }
  //   return null;
  // }
}
