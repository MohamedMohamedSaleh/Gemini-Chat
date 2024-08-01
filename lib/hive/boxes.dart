import 'package:gemini_with_hive/core/constants.dart';
import 'package:gemini_with_hive/hive/chat_history.dart';
import 'package:gemini_with_hive/hive/settings.dart';
import 'package:gemini_with_hive/hive/user_model.dart';
import 'package:hive/hive.dart';

class Boxes {
  //get the chat history box
  static Box<ChatHistory> getChatHistory() => Hive.box<ChatHistory>(Constants.chatHistoryBox);

  //get the user box
  static Box<UserModel> getUser() => Hive.box<UserModel>(Constants.userBox);

  //get the settings box
  static Box<Settings> getSettings() => Hive.box<Settings>(Constants.settingsBox);
}