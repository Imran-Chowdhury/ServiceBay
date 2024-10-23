

class BookingValidator{


  static String? Validator(String? value){

    if (value == null || value.isEmpty) {
      return 'This is a required field!';
    }
    return null;
  }



}