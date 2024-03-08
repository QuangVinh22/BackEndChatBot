import 'package:chatbot/Models/usermodels.dart';
import 'package:chatbot/Service/helper_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserAlreadyExistsException implements Exception {
  final String message;
  UserAlreadyExistsException(this.message);

  @override
  String toString() => message;
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException(this.message);

  @override
  String toString() => message;
}

class InvalidatedEmailorPassword implements Exception {
  final String message;
  InvalidatedEmailorPassword(this.message);

  @override
  String toString() => message;
}

class AuthServiceApi {
  final String urlApi = "https://backendchatbot-7keg.onrender.com";
  Future<User> registerService(String username, String password) async {
    var body = json.encode({
      'email': username,
      'password': password,
    });
    final response = await http.post(Uri.parse('$urlApi/v1/Auth/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body);

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body)['data']);
    } else if (response.statusCode == 404) {
      throw NotFoundException('Không tìm thấy tài nguyên.');
    } else if (response.statusCode == 500) {
      throw UserAlreadyExistsException('Email đã tồn tại.');
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<User> loginService(String username, String password) async {
    var body = json.encode({
      'email': username,
      'password': password,
    });
    final response = await http.post(Uri.parse('$urlApi/v1/Auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body);

    if (response.statusCode == 200) {
      //decode từ response ra
      var jsonResponse = json.decode(response.body);
      //từ biến jsonresponse móc ra 2 trường access và refresh
      String accessToken = jsonResponse['data']['accessToken'];
      String refreshToken = jsonResponse['data']['refreshToken'];
      //Gọi tới helper lưu token lại
      bool result = await TokenStorage().saveToken(accessToken, refreshToken);
      // In accessToken để kiểm tra

      var userResponse = SingleUserResponse.fromJson(jsonResponse).data;
      return userResponse;
    } else if (response.statusCode == 401) {
      throw InvalidatedEmailorPassword("Sai tên đăng nhập hoặc mật khẩu");
    } else if (response.statusCode == 500) {
      throw InvalidatedEmailorPassword('Sai tên đăng nhập hoặc mật khẩu.');
    } else {
      throw Exception(
          'Failed to login with status code: ${response.statusCode}');
    }
  }
}
