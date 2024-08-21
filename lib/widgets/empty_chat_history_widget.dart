import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/chat_providers.dart';

class EmptyChatHistoryWidget extends StatelessWidget {
  const EmptyChatHistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () async {
          // navigate to chat screen
          // navigate to chat screen
          final chatProvider = context.read<ChatProvider>();
          // prepare chat room
          await chatProvider.prepareChatRoom(
            isNewChat: true,
            chatID: '',
          );
          chatProvider.setCurrentIndex(newIndex: 1);
          chatProvider.pageController.jumpToPage(1);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'No chat foune, start a new chat!',
            ),
          ),
        ),
      ),
    );
  }
}
