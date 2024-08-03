import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gemini_with_hive/models/messages.dart';
import 'package:gemini_with_hive/providers/chat_providers.dart';
import 'package:provider/provider.dart';

class PreviewImagesWidget extends StatelessWidget {
  const PreviewImagesWidget({super.key, this.message});
  final Message? message;
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(builder: (context, chatProvider, child) {
      // if message == null mean the message in textfield else the message in chat screen
      // final messageToShow =
      message != null ? message!.imagesUrls : chatProvider.imagesFileList;
      final padding = message != null
          ? EdgeInsets.zero
          : const EdgeInsets.only(left: 8, right: 8);
      return Padding(
        padding: padding,
        child: SizedBox(
          height: 80,
          child: ListView.builder(
            shrinkWrap: true,
            // reverse: true,
            scrollDirection: Axis.horizontal,
            itemCount: message != null
                ? message!.imagesUrls.length
                : chatProvider.imagesFileList!.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 4, right: 4, top: 8),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(15),
                  ),
                  child: Image.file(
                    File(message != null
                        ? message!.imagesUrls[index]
                        : chatProvider.imagesFileList![index].path),
                    width: 80,
                    fit: BoxFit.cover,
                    height: 80,
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }
}
