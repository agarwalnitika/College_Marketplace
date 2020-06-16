abstract class StringValidator {
  bool isValid( String value);
}

class Validates implements StringValidator {
  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }
}


class SignInValidator {
  final StringValidator emailValidator = Validates();
  final StringValidator passwordValidator = Validates();
  final String invalidEmailErrorText = 'Email can\'t be empty';
  final String invalidPasswordErrorText = 'Password can\'t be empty';
}

class SignUpValidator {
  final StringValidator nameValidator = Validates();
  final StringValidator phoneValidator = Validates();
  final StringValidator emailValidator = Validates();
  final StringValidator passwordValidator = Validates();
  final String invalidNameErrorText = 'Name can\'t be empty';
  final String invalidPhoneErrorText = 'Phone can\'t be empty';
  final String invalidEmailErrorText = 'Email can\'t be empty';
  final String invalidPasswordErrorText = 'Password can\'t be empty';
}