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
}