import 'package:flutter/material.dart';
import 'package:gemini_with_hive/core/my_themes.dart';
import 'package:gemini_with_hive/providers/chat_providers.dart';
import 'package:gemini_with_hive/providers/theme_provider.dart';

import 'screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await ChatProvider.initHive();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ChatProvider()),
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  void setTheme() {
    final themeProvider = context.read<ThemeProvider>();
    themeProvider.getSavedTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gemini With Hive',
      darkTheme: MyThemes.darkTheme,
      themeMode: context.watch<ThemeProvider>().isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,
      theme: MyThemes.lightTheme,
      home: const HomeScreen(),
    );
  }
}
