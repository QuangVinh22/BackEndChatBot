import 'package:chatbot/Models/conversation.dart';
import 'package:chatbot/Models/messages.dart';
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
  final String urlApi = "https://backendchatbot-7keg.onrender.com";
  String? accessToken;
  ApiService({this.accessToken});

  Future<void> initializeToken() async {
    accessToken = await TokenStorage().getAccessToken();
  }

  Future<ApiResponse> fetchListConversations() async {
    await initializeToken();
    final response = await http.get(
      Uri.parse('$urlApi/v1/Conversations/getList'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$accessToken',
      },
    );

    if (response.statusCode == 200) {
      print(response);
      return ApiResponse.fromJson(json.decode(response.body));
    }
    if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw Exception('Failed to load list');
    }
  }

  Future<ApiResponseForSingle> createaConversations(
    String name,
  ) async {
    await initializeToken();
    var body = json.encode({
      'type': "EMPTY-PROJECTS",
      'name': name,
      'messages': [],
      "userInfor": "5f7679702b5f5c002f5a3efd",
    });

    final response =
        await http.post(Uri.parse('$urlApi/v1/Conversations/create'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': '$accessToken',
            },
            body: body);

    if (response.statusCode == 200) {
      return ApiResponseForSingle.fromJson(json.decode(response.body));
    }
    if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw Exception('Failed to load list');
    }
  }

  Future<ApiResponseForSingle> pushMessageToConversations(
      String id, String messageId) async {
    await initializeToken();
    var body = json.encode({
      'type': "ADD-MESSAGES",
      'messages': [messageId],
      "_id": id
    });

    final response =
        await http.post(Uri.parse('$urlApi/v1/Conversations/create'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': '$accessToken',
            },
            body: body);

    if (response.statusCode == 200) {
      return ApiResponseForSingle.fromJson(json.decode(response.body));
    }
    if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw Exception('Failed to load list');
    }
  }

  Future<MessageApiResponse> fetchListMessagesInConversations(
      conversationId) async {
    final response = await http.get(
      Uri.parse("$urlApi/v1/Messages/getList?conversationId=$conversationId"),
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': '$accessToken',
      },
    );
    if (response.statusCode == 200) {
      return MessageApiResponse.fromJson(json.decode(response.body));
    }
    if (response.statusCode == 401) {
      throw Exception('Please Login Again');
    } else {
      throw Exception('Failed to load list');
    }
  }
}
