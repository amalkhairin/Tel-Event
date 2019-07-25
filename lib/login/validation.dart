class Validation {
  String validatePass(String value){
    if (value.length < 8) {
      return 'Password Minimal 8 Karakter';
    }
    return null;
  }

  String validateEmail(String value){
    if (!value.contains('@') || value.length < 5){
      return 'Email tidak valid';
    }
    return null;
  }
}