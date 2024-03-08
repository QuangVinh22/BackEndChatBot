import 'package:chatbot/Models/Conversation.dart';
import 'package:chatbot/Service/helper_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException([this.message = "Please login again."]);

  @override
  String toString() => message;
}

class ApiService {
  final String url_Api = "https://backendchatbot-7keg.onrender.com";
  String? accessToken;
  ApiService({this.accessToken});

  Future<void> initializeToken() async {
    accessToken = await TokenStorage().getAccessToken();
    print(accessToken);
  }

  Future<ApiResponse> fetchListConversations() async {
    await initializeToken();
    final response = await http.get(
      Uri.parse('$url_Api/v1/Conversations/getList'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$accessToken',
      },
    );

    if (response.statusCode == 200) {
      return ApiResponse.fromJson(json.decode(response.body));
    }
    if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw Exception('Failed to load list');
    }
  }

  Future<MessageApiResponse> fetchListMessagesInConversations() async {
    final response = await http.get(
      Uri.parse("$url_Api/v1/Messages/getList"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$accessToken',
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      return MessageApiResponse.fromJson(json.decode(response.body));
    }
    if (response.statusCode == 401) {
      throw Exception('Please Login Again');
    } else {
      throw Exception('Failed to load list');
    }
  }
}
