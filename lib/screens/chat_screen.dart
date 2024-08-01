import 'package:flutter/material.dart';
import 'package:gemini_with_hive/providers/chat_providers.dart';
import 'package:gemini_with_hive/widgets/assistant_widget.dart';
import 'package:gemini_with_hive/widgets/input_chat_field.dart';
import 'package:gemini_with_hive/widgets/message_widget.dart';
import 'package:provider/provider.dart';

import '../models/messages.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  void listenToScrolll() {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent -
              _scrollController.offset >
          500) {
        // User scrolled up
        if (!_showFab) {
          setState(() {
            _showFab = true;
          });
        }
      } else {
        // User scrolled down
        if (_showFab) {
          setState(() {
            _showFab = false;
          });
        }
      }
    });
  }

  void scrollToBottom() {
    return WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (_scrollController.hasClients &&
            _scrollController.position.maxScrollExtent > 0.0) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent - 3,
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
          );
        }
      },
    );
  }

  bool _showFab = false;
  @override
  void initState() {
    super.initState();
    listenToScrolll();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        chatProvider.addListener(
          () {
            if (chatProvider.inChatMessages.isNotEmpty) {
              scrollToBottom();
            }
          },
        );

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              scrolledUnderElevation: .3,
              title: const Text("Chat with Gemini"),
              centerTitle: true,
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: chatProvider.inChatMessages.isEmpty
                          ? const Center(
                              child: Text('No messages'),
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              itemCount: chatProvider.inChatMessages.length,
                              itemBuilder: (context, index) {
                                final message =
                                    chatProvider.inChatMessages[index];
                                return message.role == Role.user
                                    ? MyMessageWidget(
                                        message: message.message.toString())
                                    : AssistantMessageWidget(
                                        message: message.message.toString());
                              },
                            ),
                    ),
                    InputChatField(
                      scrollController: _scrollController,
                      chatProvider: chatProvider,
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: _showFab
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 65),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: SizedBox(
                        height: 40,
                        width: 40,
                        child: FloatingActionButton(
                          backgroundColor:
                              Colors.deepPurpleAccent.withOpacity(.7),
                          onPressed: () {
                            scrollToBottom();
                          },
                          child: const Icon(
                            Icons.arrow_downward_rounded,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                  )
                : null,
          ),
        );
      },
    );
  }
}
