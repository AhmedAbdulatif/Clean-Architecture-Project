class LoginRequest {
  String email;
  String password;
  LoginRequest(this.email, this.password);
}

class RegisterRequest {
  String userName;
  String countryCode;
  String phoneNumber;
  String email;
  String password;
  String proflePicture;
  RegisterRequest(this.userName, this.countryCode, this.phoneNumber, this.email,
      this.password, this.proflePicture);
}
