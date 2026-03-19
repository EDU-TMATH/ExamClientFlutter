class UserPayload {
  final String sub;
  final String username;
  final int exp;
  final int iat;

  UserPayload({
    required this.sub,
    required this.username,
    required this.exp,
    required this.iat,
  });

  factory UserPayload.fromJson(Map<String, dynamic> json) {
    return UserPayload(
      sub: json['sub'],
      username: json['username'],
      exp: json['exp'],
      iat: json['iat'],
    );
  }
}
