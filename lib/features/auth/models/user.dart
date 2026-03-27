class User {
  final int pk;
  final String username;

  User({required this.pk, required this.username});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(pk: json['pk'], username: json['username']);
  }
}
