class User {
  String? profileImage;
  String? username;
  String? name;

  User({
    this.profileImage,
    this.username,
    this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        profileImage: json['avatar'] as String?,
        username: json['username'] as String?,
        name: json['first_name'] + ' ' + json['last_name'] as String?,
      );
}
