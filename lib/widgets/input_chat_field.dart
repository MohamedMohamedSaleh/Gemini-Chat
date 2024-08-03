import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gemini_with_hive/core/helper.dart';
import 'package:gemini_with_hive/providers/chat_providers.dart';
import 'package:gemini_with_hive/widgets/preview_images_widget.dart';
import 'package:image_picker/image_picker.dart';

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
            widget.scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 1000),
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
      widget.chatProvider.setImagesFileList(listImage: []);
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

  // initialize image picker
  final ImagePicker imagePicker = ImagePicker();

// pick an image
  void pickImage() async {
    try {
      final image = await imagePicker.pickMultiImage(
        imageQuality: 95,
        maxHeight: 800,
        maxWidth: 800,
      );

      widget.chatProvider.setImagesFileList(listImage: image);
    } catch (ex) {
      log(ex.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    bool hasImage = widget.chatProvider.imagesFileList?.isNotEmpty ?? false;

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
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          hasImage ? const PreviewImagesWidget() : const SizedBox.shrink(),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  if (hasImage) {
                    // has images
                    showMyAnimatedDialog(
                        context: context,
                        title: "Delete all images",
                        content: "Are you sure you want to delete all images?",
                        actionText: "Delete",
                        negativeButtonAction: (value) {
                          if (value) {
                            widget.chatProvider
                                .setImagesFileList(listImage: []);
                          }
                        });
                  } else {
                    pickImage();
                  }
                },
                // splashRadius: .20,
                // padding: const EdgeInsets.only(
                //   // left: 8,
                //   top: 0,
                // ),
                icon: Icon(
                  hasImage ? Icons.delete_forever_rounded : Icons.image,
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
                  onSubmitted: widget.chatProvider.setLoading? null: (value) {
                    scrollToBottom();
                    if (value.isNotEmpty) {
                      sendChatMessage(
                        message: value,
                        chatProvider: widget.chatProvider,
                        isTextOnly: !hasImage,
                      );
                    }
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(0),
                    hintText: 'Message Chat Gemini',
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap:widget.chatProvider.setLoading? null: () {
                  //send message
                  if (messageController.text.isNotEmpty) {
                    scrollToBottom();
                    sendChatMessage(
                      message: messageController.text,
                      chatProvider: widget.chatProvider,
                      isTextOnly: !hasImage,
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
                    padding: EdgeInsets.all(6.0),
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
