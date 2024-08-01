import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gemini_with_hive/providers/chat_providers.dart';

class InputChatField extends StatefulWidget {
  const InputChatField(
      {super.key, required this.chatProvider, required this.scrollController});
  final ChatProvider chatProvider;
  final ScrollController scrollController;
  @override
  State<InputChatField> createState() => _InputChatFieldState();
}

class _InputChatFieldState extends State<InputChatField> {
  // message controller
  final messageController = TextEditingController();

  // focus node
  final textFieldFocus = FocusNode();
  void scrollToBottom() {
    return WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (widget.scrollController.hasClients &&
            widget.scrollController.position.maxScrollExtent > 0.0) {
          widget.scrollController.animateTo(
            widget.scrollController.position.maxScrollExtent - 3,
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
          );
        }
      },
    );
  }

  Future<void> sendChatMessage({
    required String message,
    required ChatProvider chatProvider,
    required bool isTextOnly,
  }) async {
    try {
      await chatProvider.sendMessage(message: message, isTextOnly: isTextOnly);
    } catch (ex) {
      log('error sending message: $ex');
    } finally {
      messageController.clear();
      textFieldFocus.unfocus();
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    textFieldFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.1), blurRadius: 20)
        ],
        border: Border.all(color: Colors.white
            // color: Theme.of(context).textTheme.titleLarge!.color!,
            ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.image,
              color: Colors.deepPurpleAccent,
            ),
          ),
          Expanded(
            child: TextField(
              minLines: 1,
              maxLines: 4,
              focusNode: textFieldFocus,
              controller: messageController,
              textInputAction: TextInputAction.send,
              onSubmitted: (value) {
                scrollToBottom();
                if (value.isNotEmpty) {
                  sendChatMessage(
                    message: value,
                    chatProvider: widget.chatProvider,
                    isTextOnly: true,
                  );
                }
              },
              decoration: InputDecoration.collapsed(
                // contentPadding: const EdgeInsets.all(8),
                hintText: 'Message Chat Gemini',
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              //send message
              if (messageController.text.isNotEmpty) {
                scrollToBottom();
                sendChatMessage(
                  message: messageController.text,
                  chatProvider: widget.chatProvider,
                  isTextOnly: true,
                );
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                borderRadius: BorderRadius.circular(30),
              ),
              margin: const EdgeInsets.all(5),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
