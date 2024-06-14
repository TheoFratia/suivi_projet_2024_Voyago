class User {
  final String uuid;
  late final String username;

  User({
    required this.uuid,
    required this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uuid: json['uuid'] as String,
      username: json['username'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'username': username,
    };
  }
}
