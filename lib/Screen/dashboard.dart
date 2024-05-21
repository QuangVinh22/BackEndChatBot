import 'package:chatbot/Models/conversation.dart';
import 'package:chatbot/Screen/Conversations/new_conversations.dart';
import 'package:chatbot/Screen/Conversations/conversationdeltails.dart';
import 'package:chatbot/Service/conversations_service.dart';

import 'package:chatbot/Widgets/SettingButton.dart';
import 'package:flutter/material.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  void _showSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return const SettingButton(); // Sử dụng lớp SettingButton của bạn
      },
    );
  }

  final ApiService apiService = ApiService();
  Future<ApiResponse>? listConversationsFuture;
  Future<void> _createNewConversation(name) async {
    try {
      ApiResponseForSingle response =
          await ApiService().createaConversations(name);
      // Xử lý response, ví dụ lưu trữ ID cuộc hội thoại mới, cập nhật UI,...
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                NewConversations(conversation: response.data)),
      );

      // Cập nhật danh sách cuộc hội thoại hoặc chuyển người dùng đến màn hình cuộc hội thoại mới
    } catch (error) {
      print("Failed to create new conversation: $error");
      // Hiển thị lỗi (nếu có) cho người dùng
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create new conversation: $error')),
      );
    }
  }

  //
  Future<void> _showNameDialog() async {
    String? name = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController _nameController = TextEditingController();
        return AlertDialog(
          title: const Text('Enter Conversation Name'),
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(hintText: "Conversation Name"),
            style: const TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(_nameController.text);
              },
            ),
          ],
        );
      },
    );

    if (name != null && name.isNotEmpty) {
      _createNewConversation(name);
    }
  }

  @override
  void initState() {
    super.initState();
    // Gán giá trị Future từ API vào biến để sử dụng trong FutureBuilder
    listConversationsFuture = ApiService().fetchListConversations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 52, 53, 65),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 52, 53, 65),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.messenger_outline_sharp,
            color: Colors.white,
          ),
        ),
        title: TextButton(
          onPressed: () async {
            _showNameDialog();
          },
          child: const Text(
            "New Chat",
            style: TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              //Mở setting
              _showSettingsBottomSheet(context);
            },
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const Divider(),
          Expanded(
            child: FutureBuilder<ApiResponse>(
              future: listConversationsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.data.length,
                    itemBuilder: (context, index) {
                      Conversation conversation = snapshot.data!.data[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ConversationDetails(
                                      hasUserAsked: true,
                                      conversation: conversation,
                                    )),
                          );
                        },
                        child: ListTile(
                          title: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.messenger_outline_rounded,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    width: 44,
                                  ),
                                  Expanded(
                                    child: Text(
                                      conversation.name,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  const SizedBox(width: 30),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.more_vert,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text("No data"));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
