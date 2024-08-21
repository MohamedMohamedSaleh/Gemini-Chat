import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
      print(_scrollController.position.maxScrollExtent);
      print(_scrollController.offset);
      if (_scrollController.position.maxScrollExtent -
              _scrollController.offset >
          300) {
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration.zero, () {
        // Ensure layout is complete
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
          );
        }
      });
    });
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
              title: const Text("Gemini GPT"),
              centerTitle: true,
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              actions: [
                if (chatProvider.inChatMessages.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GestureDetector(
                      onTap: () {
                        // prepare new chat
                        chatProvider.prepareChatRoom(
                            isNewChat: true, chatID: '');
                      },
                      child: const CircleAvatar(
                        radius: 18.0,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.add_comment_outlined,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  children: [
                    Expanded(
                      child: chatProvider.inChatMessages.isEmpty
                          ? const Center(
                              child: Text('No messages'),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.only(bottom: 4),
                              controller: _scrollController,
                              itemCount: chatProvider.inChatMessages.length,
                              itemBuilder: (context, index) {
                                final message =
                                    chatProvider.inChatMessages[index];
                                return message.role == Role.user
                                    ? MyMessageWidget(message: message)
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
            // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
                            Icons.keyboard_double_arrow_down_rounded,
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
