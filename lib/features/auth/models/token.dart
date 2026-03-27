class Token {
  final String access;
  final String refresh;

  Token({required this.access, required this.refresh});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(access: json['access_token'], refresh: json['refresh_token']);
  }
}
