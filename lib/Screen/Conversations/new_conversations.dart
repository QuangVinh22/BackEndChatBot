import 'package:chatbot/Models/conversation.dart';
import 'package:chatbot/Service/message_service.dart';

import 'package:chatbot/Widgets/input_question.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class NewConversations extends StatefulWidget {
  const NewConversations({super.key, required this.conversation});
  final Conversation conversation;
  @override
  State<NewConversations> createState() => _ConversationDetailsState();
}

class _ConversationDetailsState extends State<NewConversations> {
  bool isTyping = false;

  String typedQuestion = "";

  final TextEditingController _controller = TextEditingController();
  void _handleTextChange(String text) {
    setState(() {
      isTyping = text.isNotEmpty;
      typedQuestion = text;
    });
  }

  void storeMessages(String text, String reply) {
    setState(() {
      messages.add(text);
      messages.add(reply);
    });
  }

  Future<void> storeMessageToDBforUser(String text) async {
    try {
      // Gọi MessageService để gửi tin nhắn
      final response = await MessageService()
          .createMessageforUser(text, widget.conversation.id);
    } catch (error) {
      ("Failed to store message: $error");
      // Hiển thị lỗi (nếu có) cho người dùng
    }
  }

  Future<void> storeMessageToDBforChatBot(String text) async {
    try {
      // Gọi MessageService để gửi tin nhắn
      final response = await MessageService()
          .createMessageforChatBot(text, widget.conversation.id);
    } catch (error) {
      ("Failed to store message: $error");
      // Hiển thị lỗi (nếu có) cho người dùng
    }
  }

  List<String> messages = [];
  Future<void> sendMessage(String text) async {
    const String apiKey =
        "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"; // Thay "YOUR_API_KEY" bằng API Key thực tế của bạn
    final uri = Uri.parse('https://api.openai.com/v1/chat/completions');

    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: json.encode(<String, dynamic>{
          "model": "ft:gpt-3.5-turbo-0125:personal::9BnMMp8a",
          "messages": [
            {"role": "user", "content": text}
          ],
          "max_tokens": 30,
          "temperature": 0
        }),
      );
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);

        String replyText = result['choices'][0]['message']['content'].trim();
        storeMessages(text, replyText);
        storeMessageToDBforUser(text);
        storeMessageToDBforChatBot(replyText);
        // Cập nhật UI hoặc xử lý phản hồi như mong muốn
      } else {
        throw Exception('Failed to load data from OpenAI');
      }
    } catch (error) {
      ("Failed to send message: $error");
      // Xử lý lỗi ở đây
    }
  }

  Widget content = const Column(
    children: [
      Divider(),
      Center(
        child: Text("Ask Anything , get your answer"),
      )
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 52, 53, 65),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          title: const Text(
            "Chat Details",
            style: TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.w400),
          ),
          actions: [
            SizedBox(
              width: 40,
              height: 40,
              child: Image.asset(
                "assets/cc3.png",
                color: Colors.white,
              ),
            )
          ],
        ),
        // body: Stack(
        //   children: [
        //     if (!isTyping) ...[
        //       const Align(
        //         alignment: Alignment.center,
        //         child: Text(
        //           "Ask anything, get your answer",
        //           textAlign: TextAlign.center,
        //           style: TextStyle(color: Colors.grey),
        //         ),
        //       )
        //     ] else ...[
        //       Align(
        //         alignment: Alignment.topRight,
        //         child: Container(
        //           padding: const EdgeInsets.symmetric(
        //               horizontal: 16.0,
        //               vertical: 8.0), // Padding bên trong container
        //           decoration: BoxDecoration(
        //             color: Colors.teal, // Màu nền của container
        //             borderRadius: BorderRadius.circular(20), // Bo tròn góc
        //             boxShadow: [
        //               BoxShadow(
        //                 color: Colors.black.withOpacity(0.1), // Màu bóng
        //                 spreadRadius: 1,
        //                 blurRadius: 2,
        //                 offset:
        //                     const Offset(0, 1), // changes   position of shadow
        //               ),
        //             ],
        //           ),
        //           child: Text(
        //             typedQuestion, // Text được nhập từ người dùng
        //             style: const TextStyle(
        //               color: Colors.white, // Màu chữ
        //               fontWeight: FontWeight.bold, // Độ đậm của chữ
        //             ),
        //           ),
        //         ),
        //       )
        //     ],
        //     Align(
        //       alignment: Alignment.bottomCenter,
        //       child: Padding(
        //         padding:
        //             const EdgeInsets.all(16.0), // Điều chỉnh padding theo nhu cầu
        //         child: InputQuestion(
        //             onSendMessage: sendMessage,
        //             onTextChanged: _handleTextChange), // Widget của bạn
        //       ),
        //     ),
        //   ],
        // ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  // Dùng biến để xác định liệu tin nhắn hiện tại là từ người dùng hay bot
                  bool isUserMessage = index % 2 == 0;
                  // Dùng biến để xác định liệu avatar nên hiển thị bên trái hay bên phải
                  CrossAxisAlignment alignment = isUserMessage
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start;
                  // Dùng biến để xác định màu nền của tile
                  Color backgroundColor = isUserMessage
                      ? Colors.blueAccent[100] ??
                          const Color.fromARGB(255, 158, 160,
                              162) // Nếu không có màu blueAccent[100], sử dụng màu blue mặc định
                      : const Color.fromARGB(
                          255, 116, 112, 111); // Tương tự cho màu green[100]

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: isUserMessage
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      crossAxisAlignment: alignment,
                      children: [
                        // Hiển thị avatar bên trái nếu tin nhắn từ bot, ngược lại hiển thị avatar bên phải
                        if (!isUserMessage)
                          SizedBox(width: 8), // Khoảng cách avatar
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: AssetImage(isUserMessage
                              ? "assets/download.png"
                              : "assets/cc3.png"),
                        ),
                        SizedBox(
                            width:
                                8), // Khoảng cách giữa avatar và nội dung tin nhắn
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            messages[index],
                            softWrap: true,
                          ),
                        ),
                        if (isUserMessage)
                          SizedBox(width: 8), // Khoảng cách avatar
                      ],
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: InputQuestion(
                    controller: _controller,
                    onSendMessage: sendMessage,
                    onTextChanged: _handleTextChange),
              ),
            ),
          ],
        ));
  }
}
