import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/chat_providers.dart';
import 'chat_history_screen.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // list of screens
  final List<Widget> _screens = [
    const ChatHistoryScreen(),
    const ChatScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(builder: (context, chatProvider, child) {
      return Scaffold(
        body: PageView(
          controller: chatProvider.pageController,
          onPageChanged: (index) {
            chatProvider.setCurrentIndex(newIndex: index);
          },
          children: _screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0.0,
          selectedFontSize: 14,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          selectedItemColor: Theme.of(context).colorScheme.primary,
          currentIndex: chatProvider.currentIndex,
          onTap: (index) {
            chatProvider.setCurrentIndex(newIndex: index);

            chatProvider.pageController.jumpToPage(index);
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.history), label: 'Chat History'),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      );
    });
  }
}
