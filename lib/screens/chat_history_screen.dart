import 'package:flutter/material.dart';
import 'package:gemini_with_hive/hive/boxes.dart';
import 'package:gemini_with_hive/hive/chat_history.dart';
import 'package:gemini_with_hive/widgets/chat_history_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key});

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: .3,
        title: const Text("Chat History"),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),

      /** ValueListenableBuilder => is a widget in Flutter
       *  that rebuilds its child widget whenever the value
       *  of a ValueListenable changes. It's particularly useful
       *  for efficiently updating the UI in response to changes
       *  in a value without needing to use more complex state management
       *  solutions.*/
      body: ValueListenableBuilder<Box<ChatHistory>>(
        valueListenable: Boxes.getChatHistory().listenable(),
        builder: (context, box, _) {
          final chatHistory = box.values.toList().cast<ChatHistory>();
          return chatHistory.isEmpty
              ? const SizedBox()
              : ListView.builder(
                  itemCount: chatHistory.length,
                  itemBuilder: (context, index) {
                    final chat = chatHistory[index];
                    return ChatHistoryWidget(chat: chat);
                  },
                );
        },
      ),
    );
  }
}
