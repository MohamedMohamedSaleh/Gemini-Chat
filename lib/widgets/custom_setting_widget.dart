import 'package:flutter/material.dart';

class CustomSettingWidget extends StatelessWidget {
  const CustomSettingWidget(
      {super.key,
      required this.icon,
      required this.title,
      required this.value,
      required this.onChanged});

  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          radius: 20,
          child: Icon(
            icon,
            size: 26,
          ),
        ),
        title: Text(title),
        trailing: SizedBox(
            width: 26,
            child: Switch(
              splashRadius: 20,
              value: value,
              onChanged: onChanged,
            )),
      ),
    );
  }
}
