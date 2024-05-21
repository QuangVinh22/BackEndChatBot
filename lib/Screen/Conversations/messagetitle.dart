import 'package:chatbot/Models/messages.dart';
import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {
  final Message message;
  final bool isUserMessage;

  const MessageTile(
      {Key? key, required this.message, required this.isUserMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final alignment =
        isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final mainAxisSize = isUserMessage ? MainAxisSize.min : MainAxisSize.max;
    final color = isUserMessage
        ? Colors.blue[200]
        : const Color.fromARGB(255, 59, 59, 59);
    final iconPath = isUserMessage ? "assets/download.png" : "assets/cc3.png";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment:
            isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: alignment,
        mainAxisSize:
            mainAxisSize, // Sử dụng MainAxisSize để giữ cho Row nhỏ nhất có thể
        children: [
          if (!isUserMessage) // Nếu tin nhắn từ bot, thêm avatar bên trái
            CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage(iconPath),
            ),
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              message.text,
              style: const TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 255, 255, 254),
              ),
              softWrap: true,
            ),
          ),
          if (isUserMessage) // Nếu tin nhắn từ người dùng, thêm avatar bên phải
            CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage(iconPath),
            ),
        ],
      ),
    );
  }
}
