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

class MessageService {
  final String urlApi = "https://backendchatbot-7keg.onrender.com";
  String? accessToken;
  MessageService({this.accessToken});

  Future<void> initializeToken() async {
    accessToken = await TokenStorage().getAccessToken();
  }

  Future<MessageApiResponse> createMessageforUser(
      String text, String conversationId) async {
    var body = json.encode({
      "text": text,
      "conversationId": conversationId,
      "senderType": "user",
    });
    await initializeToken();
    final response = await http.post(
      Uri.parse('$urlApi/v1/Messages/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      return MessageApiResponse.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw Exception('Failed to load list');
    }
  }

  Future<MessageApiResponse> createMessageforChatBot(
      String text, String conversationId) async {
    var body = json.encode({
      "text": text,
      "conversationId": conversationId,
      "senderType": "bot",
    });
    await initializeToken();
    final response = await http.post(
      Uri.parse('$urlApi/v1/Messages/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      return MessageApiResponse.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw Exception('Failed to load list');
    }
  }
}
