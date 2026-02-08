class UserModel {
  final int? id;
  final String username;
  final String? password;
  final String role;
  final String? token;

  UserModel({
    this.id,
    required this.username,
    this.password,
    required this.role,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      role: json['role'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      if (password != null) 'password': password,
      'role': role,
      if (token != null) 'token': token,
    };
  }
}
