class Message {
  final String id;
  final String text;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String conversationId;
  final String senderType;
  bool isUserMessage;
  Message(
      {required this.id,
      required this.text,
      required this.createdAt,
      required this.updatedAt,
      required this.conversationId,
      required this.senderType,
      this.isUserMessage = true});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id'],
      text: json['text'],
      senderType: json['senderType'],
      conversationId: json['conversationId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class MessageApiResponse {
  final int ec;
  final List<Message> data;

  MessageApiResponse({required this.ec, required this.data});

  factory MessageApiResponse.fromJson(Map<String, dynamic> json) {
    List<Message> dataList;
    if (json['data'] is List) {
      // Trường hợp 'data' là một mảng
      dataList =
          (json['data'] as List).map((i) => Message.fromJson(i)).toList();
    } else {
      // Trường hợp 'data' là một đối tượng
      dataList = [Message.fromJson(json['data'])];
    }

    return MessageApiResponse(
      ec: json['EC'],
      data: dataList,
    );
  }
}
