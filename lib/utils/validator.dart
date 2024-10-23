class Validator{


  static String? personNameValidator(String? value){

    if (value == null || value.isEmpty) {
      return 'Please enter a name!';
    }
    return null;
  }

  static String? emailValidator(String? value){

    if (value == null || value.isEmpty) {
      return 'Please enter an email!';
    }
    return null;
  }

  static String? passwordValidator(String? value){

    if (value == null || value.isEmpty) {
      return 'Please enter a password!';
    }
    if(value.length < 6 ){
      return'Password too short';
    }
    return null;
  }



  static String? confirmPasswordValidator(String? value){

    if (value == null || value.isEmpty) {
      return 'Please confirm the password!';
    }
    return null;
  }


}