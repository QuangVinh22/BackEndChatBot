class SingleUserResponse {
  final int ec;
  final User data;
  
  SingleUserResponse({required this.ec, required this.data});

  factory SingleUserResponse.fromJson(Map<String, dynamic> json) {
    return SingleUserResponse(
      ec: json['EC'] as int,
      data: User.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class User {
  final String? id;
  final String? password;
  final String? username;
  final String? accesstoken; // Đánh dấu là optional
  final String? refreshtoken;
  final bool? deleted;

  User(
      {this.username,
      this.id,
      this.password,
      this.accesstoken, // Không cần required vì là optional
      this.refreshtoken,
      this.deleted});

  factory User.fromJson(Map<String, dynamic> json) {
    print("JSON data: $json");
    return User(
      id: json['_id'] ?? "cc",
      username: json[
          'username'], // Dùng 'email' cho đăng ký, 'username' cho đăng nhập nếu cần
      password: json['password'],
      accesstoken:
          json['accessToken'], // Có thể không có trong phản hồi đăng ký
      refreshtoken:
          json['refreshToken'], // Có thể không có trong phản hồi đăng ký
    );
  }
}
