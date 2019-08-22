class Validation {
  String validatePass(String value){
    if (value.isEmpty){
      return 'password can\'t be empty';
    } else {
      if (value.length < 6){
        return 'password should be at least 6 characters';
      }
    }
    return null;
  }

  String validateEmail(String value){
    if (value.isNotEmpty){
      // RegEx email pattern validation
      Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = new RegExp(pattern);
      if (regExp.hasMatch(value)){
        return null;
      }
      return 'email isn\'t valid';
    } else {
      return 'email can\'t be empty';
    }
  }

  String validateUsername(String value){
    if (value.isEmpty){
      return 'username can\'t be empty';
    }
    return null;
  }

  String validatePhone(int number){
    if(number != null){
      Pattern pattern = r'(\+62 ((\d{3}([ -]\d{3,})([- ]\d{4,})?)|(\d+)))|(\(\d+\) \d+)|\d{3}( \d+)+|(\d+[ -]\d+)|\d+$';
      RegExp regExp = new RegExp(pattern);
      if (regExp.hasMatch(number.toString())){
        return null;
      }
      return 'phone number isn\'t valid';
    } else {
      return 'phone number can\'t be empty';
    }
  }
}