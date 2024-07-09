class UsernameValidator {
  static String? validate(String value) {

    //Username is empty
    if(value.isEmpty) {
      return 'Username is required';
    }

    //check if username has only letters and numbers
    if(!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
      return 'Username should only contain letters and numbers';
    }

    return null;
  }
}

class EmailValidator {
  static String? validate(String value) {

    //Email is empty
    if(value.isEmpty) {
      return 'Email is required';
    }

    //Email Format
    if(!RegExp(r'^[\w.-]+@[\w-]+\.[\w-]{2,4}$').hasMatch(value)) {
      return 'Enter a valid Email Address';
    }

    return null;

  }
}

class PasswordValidator {
  static String? validate(String value) {

    //Password is empty
    if(value.isEmpty) {
      return 'Password is required';
    }

    //Check if value has at least one digit
    if(!value.contains(RegExp(r'\d'))) {
      return 'Password must contain a numeric value';
    }

    //Check if value has at least one letter
    if(!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain a simple letter';
    }

    //check for capital letters
    if(!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain a capital letters';
    }

    //Password Format
    if(!value.contains(RegExp(r'^.{6,}$'))) {
      return 'Password must contain at least 6 characters';
    }

    return null;

  }
}

class PasswordConfirm {
  static String? validate(String value, String revalue) {

    //Password Confirm
    if(value != revalue) {
      return "Password doesn't match";
    }

    return null;
  }
}