class ApiResponse {
  final int ec;
  final List<Conversation> data;

  ApiResponse({required this.ec, required this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<Conversation> dataList =
        list.map((i) => Conversation.fromJson(i)).toList();
    return ApiResponse(
      ec: json['EC'],
      data: dataList,
    );
  }
}

class MessageApiResponse {
  final int ec;
  final List<Message> data;

  MessageApiResponse({required this.ec, required this.data});

  factory MessageApiResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<Message> dataList = list.map((i) => Message.fromJson(i)).toList();
    return MessageApiResponse(
      ec: json['EC'],
      data: dataList,
    );
  }
}

class Conversation {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Message>? messages;
  Conversation(
      {this.messages,
      required this.name,
      required this.id,
      required this.createdAt,
      required this.updatedAt});

  factory Conversation.fromJson(Map<String, dynamic> json) {
    List<Message> messagesList = [];
    if (json['messages'] != null) {
      json['messages'].forEach((v) {
        messagesList.add(Message.fromJson(v));
      });
    }
    return Conversation(
      name: json['name'] ?? 'noname',
      messages: messagesList,
      id: json['_id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class Message {
  final String id;
  final String text;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String conversationId;
  Message(
      {required this.id,
      required this.text,
      required this.createdAt,
      required this.updatedAt,
      required this.conversationId});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id'],
      text: json['text'],
      conversationId: json['conversationId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
