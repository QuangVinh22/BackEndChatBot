import 'package:chatbot/Models/conversation.dart';
import 'package:chatbot/Models/messages.dart';
import 'package:chatbot/Screen/Conversations/messagetitle.dart';
import 'package:chatbot/Service/conversations_service.dart';
import 'package:chatbot/Service/message_service.dart';
import 'package:chatbot/Widgets/input_question.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class ConversationDetails extends StatefulWidget {
  const ConversationDetails(
      {super.key, required this.conversation, required this.hasUserAsked});
  final bool hasUserAsked;
  final Conversation conversation;

  @override
  State<ConversationDetails> createState() => _ConversationDetailsState();
}

class _ConversationDetailsState extends State<ConversationDetails> {
  final ScrollController _scrollController = ScrollController();
  List<String> messages = [];

  String typedQuestion = "";

  late Future<MessageApiResponse> _messagesFuture;

  @override
  void initState() {
    super.initState();
    // Khởi tạo Future một lần và gán nó cho biến _messagesFuture.
    _messagesFuture =
        ApiService().fetchListMessagesInConversations(widget.conversation.id);
  }

  @override
  void dispose() {
    _scrollController
        .dispose(); // Đừng quên dispose controller khi không cần nữa
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  final TextEditingController _controller = TextEditingController();
  void _handleTextChange(String text) {
    setState(() {
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

//
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
        setState(() {
          _scrollToBottom();
        });
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
        title: Text(
          widget.conversation.name,
          style: const TextStyle(
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
      body: Column(
        children: [
          const Divider(),
          Expanded(
            child: FutureBuilder<MessageApiResponse>(
              future: _messagesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: snapshot.data!.data.length,
                    itemBuilder: (context, index) {
                      Message message = snapshot.data!.data[
                          index]; // Bạn cần thêm trường này hoặc một cách xác định tương tự trong model của bạn
                      bool isUserMessage = message.senderType == "user";
                      return MessageTile(
                        message: message,
                        isUserMessage:
                            isUserMessage, // Đảm bảo truyền biến này vào MessageTile
                      );
                    },
                  );
                } else {
                  return const Center(child: Text("No data"));
                }
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
      ),
    );
  }
}
