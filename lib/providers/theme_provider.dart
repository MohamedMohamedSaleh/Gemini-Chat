import 'package:flutter/material.dart';

import '../hive/boxes.dart';
import '../hive/settings.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;


  // get the saved settings from box
  void getSavedTheme() {
    final settingsBox = Boxes.getSettings();

    // check is the settings box is open
    if (settingsBox.isNotEmpty) {
      // get the settings
      final settings = settingsBox.getAt(0);
      _isDarkMode = settings!.isDarkTheme;
    }
  }

  // toggle the dark mode
  void toggleDarkMode({
    required bool value,
    Settings? settings,
  }) {
    if (settings != null) {
      settings.isDarkTheme = value;
      settings.save();
    } else {
      // get the settings box
      final settingsBox = Boxes.getSettings();
      // save the settings
      settingsBox.put(
          0, Settings(isDarkTheme: value,));
    }

    _isDarkMode = value;
    notifyListeners();
  }
}
