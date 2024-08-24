import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gemini_with_hive/hive/settings.dart';
import 'package:gemini_with_hive/providers/theme_provider.dart';
import 'package:gemini_with_hive/widgets/custom_my_image.dart';
import 'package:gemini_with_hive/widgets/custom_setting_widget.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../hive/boxes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? file;
  String userImage = '';
  String userName = "Mohamed Saleh";
  final ImagePicker imagePicker = ImagePicker();

  Future<void> selectImage() async {
    try {
      final selectImage = await imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      if (selectImage != null) {
        setState(() {
          file = File(selectImage.path);
        });
      }
    } catch (ex) {
      debugPrint(ex.toString());
    }
  }

  void getUserData() {
    // get user data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // get user data from hive
      final userDataBox = Boxes.getUser();

      // check is user data box is open or empty
      if (userDataBox.isNotEmpty) {
        setState(() {
          userName = userDataBox.getAt(0)!.name;
          userImage = userDataBox.getAt(0)!.image;
        });
      }
    });
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CircleAvatar(
              radius: 20,
              child: IconButton(
                icon: const Icon(
                  Icons.save_as_rounded,
                  size: 24,
                ),
                onPressed: () {
                  // save data
                },
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            // mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: CustomMyImage(
                  file: file,
                  userImage: userImage,
                  onTap: () {
                    // open garally and select image.
                    selectImage();
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                userName,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 40,
              ),
              ValueListenableBuilder<Box<Settings>>(
                valueListenable: Boxes.getSettings().listenable(),
                builder: (context, settingBox, child) {
                  if (settingBox.isEmpty) {
                    return Column(
                      children: [
                        CustomSettingWidget(
                            icon: Icons.dark_mode_rounded,
                            title: "Dark Theme",
                            value: false,
                            onChanged: (value) {
                              context
                                  .read<ThemeProvider>()
                                  .toggleDarkMode(value: value);
                            }),
                      ],
                    );
                  } else {
                    final settings = settingBox.getAt(0)!;
                    return Column(
                      children: [
                        CustomSettingWidget(
                            icon: Icons.dark_mode_rounded,
                            title: "Dark Theme",
                            value: settings.isDarkTheme,
                            onChanged: (value) {
                              context
                                  .read<ThemeProvider>()
                                  .toggleDarkMode(value: value, settings: settings);
                            }),
                      ],
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
