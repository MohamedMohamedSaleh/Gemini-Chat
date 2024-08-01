import 'package:flutter/material.dart';
import 'package:gemini_with_hive/providers/chat_providers.dart';

import 'screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ChatProvider.initHive();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ChatProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gemini With Hive',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
