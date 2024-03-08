import 'package:chatbot/Models/Conversation.dart';
import 'package:chatbot/Service/conversations_service.dart';
import 'package:flutter/material.dart';

class ConversationDetails extends StatefulWidget {
  const ConversationDetails(
      {super.key, this.conversation, required this.hasUserAsked});
  final bool hasUserAsked;
  final Conversation? conversation;

  @override
  State<ConversationDetails> createState() => _ConversationDetailsState();
}

class _ConversationDetailsState extends State<ConversationDetails> {
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
          widget.conversation?.name ?? "Chat Details",
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
      body: widget.conversation == null
          ? const Column(
              children: [
                Divider(),
                Center(
                  child: Text("Ask anything, Get your anwser"),
                ),
              ],
            )
          : Column(
              children: [
                const Divider(),
                Expanded(
                  child: FutureBuilder<MessageApiResponse>(
                    future: ApiService().fetchListMessagesInConversations(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.data.length,
                          itemBuilder: (context, index) {
                            Message message = snapshot.data!.data[index];
                            return InkWell(
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
                                            message.text,
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
                                            icon:
                                                const Icon(Icons.arrow_forward),
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
                )
              ],
            ),
    );
  }
}
