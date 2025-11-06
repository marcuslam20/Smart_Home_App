class LoginResponseModel {
  final String token;
  final String username;

  LoginResponseModel({required this.token, required this.username});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json['token']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
    );
  }
}
