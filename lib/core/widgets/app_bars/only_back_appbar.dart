import 'package:flutter/material.dart';

class OnlyBackAppBar extends AppBar implements PreferredSizeWidget {
  OnlyBackAppBar({this.titleWidget, super.key});
  final Widget? titleWidget;

  AppBar build(BuildContext context) {
    return AppBar(
      title: titleWidget,
      leading: const Icon(Icons.arrow_back, color: Colors.black // mainColor,
          ),
    );
  }
}
