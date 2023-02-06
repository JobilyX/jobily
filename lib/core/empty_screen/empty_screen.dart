import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../constant/colors/colors.dart';
import '../constant/styles/styles.dart';

class EmptyScreenData extends StatelessWidget {
  final String text;
  final String image;
  const EmptyScreenData({super.key, required this.text, required this.image});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image),
          const SizedBox(
            height: 20,
          ),
          Text(
            tr(text),
            style: TextStyles.bodyText20.copyWith(color: mainColor),
          ),
        ],
      ),
    );
  }
}
