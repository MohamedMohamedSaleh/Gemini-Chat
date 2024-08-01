import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AssistantMessageWidget extends StatelessWidget {
  const AssistantMessageWidget({
    super.key,
    required this.message,
  });
  final String message;

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: const Duration(milliseconds: 500),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            // key: index == 0 ? itemKey : null,
            title: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  constraints: BoxConstraints(
                    // maxHeight: 300,
                    maxWidth: message.isEmpty
                        ? 50
                        : MediaQuery.of(context).size.width * .85,
                  ),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(
                          0,
                        ),
                        bottomRight: Radius.circular(16),
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16)),
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Colors.grey.shade300.withOpacity(.5),
                          Colors.grey.shade300.withOpacity(.8),
                        ]),
                  ),
                  child: message.isEmpty
                      ? const SizedBox(
                          width: 50,
                          child: SpinKitThreeBounce(
                            color: Colors.blueGrey,
                            size: 20,
                            duration: Duration(milliseconds: 700),
                          ),
                        )
                      : Text(
                          message,
                          style: const TextStyle(color: Colors.black),
                        )),
            ),
          ),
        ],
      ),
    );
  }
}
