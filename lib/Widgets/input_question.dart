import 'package:flutter/material.dart';

class InputQuestion extends StatefulWidget {
  const InputQuestion(
      {super.key,
      required this.controller,
      required this.onSendMessage,
      required this.onTextChanged});
  final Function(String) onTextChanged;
  final Function(String) onSendMessage;
  final TextEditingController controller;
  @override
  State<InputQuestion> createState() => _InputQuestionState();
}

class _InputQuestionState extends State<InputQuestion> {
  void _sendMessages(String messageText) {
    if (messageText.trim().isNotEmpty) {
      widget.onSendMessage(messageText.trim());
    }
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: widget.onTextChanged,
      controller: widget.controller,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: () {
            if (widget.controller.text.trim().isNotEmpty) {
              widget.onSendMessage(widget.controller.text.trim());
              widget.controller.clear(); // Xóa trường nhập sau khi gửi
            }
          },
          icon: const Icon(
            Icons.send,
            color: Colors.green,
          ),
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
