import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:gemini_with_hive/models/messages.dart';
import 'package:gemini_with_hive/widgets/preview_images_widget.dart';

class MyMessageWidget extends StatelessWidget {
  const MyMessageWidget({
    super.key,
    required this.message,
  });
  final Message message;

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: const Duration(milliseconds: 500),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.only(right: 16),
            title: Align(
              alignment: Alignment.centerRight,
              child: Container(
                  constraints: BoxConstraints(
                    // maxHeight: 300,
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(
                          16,
                        ),
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16)),
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Colors.deepPurpleAccent,
                          Colors.deepPurpleAccent.withOpacity(.7)
                        ]),
                    color: Colors.grey.shade300,
                  ),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (message.imagesUrls.isNotEmpty)
                        PreviewImagesWidget(
                          message: message,
                        ),
                      Text(
                        message.message.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  )),
            ),
          ),

          //loading
        ],
      ),
    );
  }
}
