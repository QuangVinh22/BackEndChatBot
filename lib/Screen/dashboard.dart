import 'package:chatbot/Models/Conversation.dart';
import 'package:chatbot/Screen/conversationdeltails.dart';
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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ConversationDetails(
                        hasUserAsked: false,
                      )),
            );
          },
          icon: const Icon(
            Icons.messenger_outline_sharp,
            color: Colors.white,
          ),
        ),
        title: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ConversationDetails(
                        hasUserAsked: false,
                      )),
            );
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
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.arrow_forward),
                                      color: Colors.white)
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
