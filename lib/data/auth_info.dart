class AuthInfo {
  final String accessToken;
  final String refreshToken;
  final String email;

  AuthInfo(this.accessToken, this.refreshToken, this.email);
  AuthInfo.fromJson(dynamic json)
      : accessToken = json['access_token'],
        refreshToken = json['refresh_token'],
        email = json['email'];
}
