import 'package:hive_flutter/hive_flutter.dart';

part 'settings.g.dart';
@HiveType(typeId: 2)
class Settings extends HiveObject {
  @HiveField(0)
  bool isDarkTheme = false;

  // constructor
  Settings({
    required this.isDarkTheme,
  });
}
